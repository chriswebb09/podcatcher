import UIKit
import CoreData

enum HomeInteractionMode {
    case subscription, edit
}

class HomeViewController: BaseCollectionViewController {
    
    // MARK: - Properties
    
    let userID: String = "none"
    var mode: HomeInteractionMode = .subscription
    weak var delegate: HomeViewControllerDelegate?
    
    var items = [Subscription]()
    
    var managedContext: NSManagedObjectContext! {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        let context = appDelegate.persistentContainer.viewContext
        return context
    }
    
    lazy var fetchedResultsController:NSFetchedResultsController<Subscription> = {
        let fetchRequest:NSFetchRequest<Subscription> = Subscription.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "feedUrl", ascending: true)]
        var controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedContext, sectionNameKeyPath: nil, cacheName: nil)
        try! controller.performFetch()
        return controller
    }()
    
    var itemCount: Int {
        return self.homeDataSource.itemCount
    }
    
    var homeDataSource: CollectionViewDataSource<HomeViewController>! {
        didSet {
            self.contentState = homeDataSource.contentState
        }
    }
    
    var contentState: ContentState = .empty {
        didSet {
            switch self.contentState {
            case .empty:
                self.view.sendSubview(toBack: collectionView)
                self.view.bringSubview(toFront: emptyView)
            case .collection:
                self.view.sendSubview(toBack: emptyView)
                self.view.bringSubview(toFront: collectionView)
            }
        }
    }
    
    let persistentContainer = NSPersistentContainer(name: "PodCatcher")
    
    // MARK: - UI Properties
    
    lazy var animator: UIViewPropertyAnimator = {
        let cubicParameters = UICubicTimingParameters(controlPoint1: CGPoint(x: 0, y: 0.5), controlPoint2: CGPoint(x: 1.0, y: 0.5))
        let animator = UIViewPropertyAnimator(duration: 1.0, timingParameters: cubicParameters)
        animator.isInterruptible = true
        return animator
    }()
    
    
    init(dataSource: BaseMediaControllerDataSource) {
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(collectionView: UICollectionView, dataSource: BaseMediaControllerDataSource) {
        self.init(dataSource: dataSource)
        self.collectionView = collectionView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView(view: view, newLayout: HomeItemsFlowLayout())
        collectionView.register(SubscribedPodcastCell.self)
        collectionView.setupBackground(frame: view.bounds)
        guard let background = collectionView.backgroundView else { return }
        CALayer.createGradientLayer(with: [UIColor.white.cgColor, UIColor.darkGray.cgColor], layer: background.layer, bounds: collectionView.bounds)
        rightButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(changeMode))
        rightButtonItem.tintColor = .white
        navigationItem.setRightBarButton(rightButtonItem, animated: false)
        reloadData()
        homeDataSource = CollectionViewDataSource(collectionView: collectionView, identifier: SubscribedPodcastCell.reuseIdentifier, fetchedResultsController: fetchedResultsController, delegate: self)
        collectionView.dataSource = homeDataSource
        homeDataSource.reloadData()
        collectionView.delegate = self
        view.bringSubview(toFront: collectionView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadData()
        tabBarController?.tabBar.isHidden = false
        navigationController?.navigationBar.topItem?.title = "Subscribed Podcasts"
        homeDataSource.reloadData()
    }
}

extension HomeViewController: UIScrollViewDelegate, CollectionViewProtocol {
    
    func setup(with newLayout: HomeItemsFlowLayout) {
        newLayout.setup()
        collectionView.collectionViewLayout = newLayout
        collectionView.frame = UIScreen.main.bounds
    }
    
    func setupCollectionView(view: UIView, newLayout: HomeItemsFlowLayout) {
        setup(with: newLayout)
        collectionView.frame = UIScreen.main.bounds
    }
    
    @objc func changeMode() {
        mode = mode == .edit ? .subscription : .edit
        rightButtonItem.title = mode == .edit ? "Done" : "Edit"
        collectionView.reloadData()
    }
}

extension HomeViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        switch mode {
        case .subscription:
            guard let cell = cell else { return }
            SpinAnimation.animate(from: cell, with: 2, completion: nil)
            let item = fetchedResultsController.object(at: indexPath)
            var caster = CasterSearchResult()
            caster.feedUrl = item.feedUrl
            guard let imageData = item.artworkImage, let image = UIImage(data: imageData as Data) else { return }
            delegate?.didSelect(at: indexPath.row, with: item, image: image)
        case .edit:
            let actionSheetController: UIAlertController = UIAlertController(title: "Are you sure?", message: "Pressing okay will remove this podcast from your subscription list.", preferredStyle: .alert)
            let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action in
                actionSheetController.dismiss(animated: false, completion: nil)
            }
            let okayAction: UIAlertAction =  UIAlertAction(title: "Okay", style: .destructive) { action in
                self.save(for: indexPath)
            }
            actionSheetController.addAction(cancelAction)
            actionSheetController.addAction(okayAction)
            self.present(actionSheetController, animated: true, completion: nil)
            if homeDataSource.itemCount == 0 {
                mode = .subscription
                rightButtonItem.title = "Edit"
            }
        }
    }
    
    func save(for indexPath: IndexPath) {
        persistentContainer.performBackgroundTask { _ in
            let feed = self.fetchedResultsController.object(at: indexPath).feedUrl
            self.managedContext.delete(self.fetchedResultsController.object(at: indexPath))
            var subscriptions = UserDefaults.loadSubscriptions()
            guard let feedUrl = feed else { return }
            
            if let index = subscriptions.index(of: feedUrl) {
                subscriptions.remove(at: index)
                UserDefaults.saveSubscriptions(subscriptions: subscriptions)
            }
            
            self.reloadData()
            
            do {
                try self.managedContext.save()
            } catch let error {
                self.showError(errorString: " \(error.localizedDescription)")
            }
        }
    }
}

extension HomeViewController {
    
    func reloadData() {
        do {
            try fetchedResultsController.performFetch()
            collectionView.reloadData()
        } catch let error {
            showError(errorString: "\(error.localizedDescription)")
        }
    }
    
    func setupCoordinator() {
        persistentContainer.loadPersistentStores { persistentStoreDescription, error in
            if let error = error {
                self.showError(errorString: "\(error.localizedDescription)")
            } else {
                do {
                    try self.fetchedResultsController.performFetch()
                } catch let error {
                    self.showError(errorString: "\(error.localizedDescription)")
                }
            }
        }
    }
}

extension HomeViewController: CollectionViewDataSourceDelegate {
    
    typealias Object = Subscription
    typealias Cell = SubscribedPodcastCell
    
    func configure(_ cell: SubscribedPodcastCell, for object: Subscription) {
        if let imageData = object.artworkImage,
            let image = UIImage(data: imageData as Data),
            let title =  object.podcastTitle {
            let model = SubscribedPodcastCellViewModel(trackName: title, albumImageURL: image)
            switch mode {
            case .edit:
                cell.configureCell(with: model, withTime: 0, mode: .edit)
                cell.bringSubview(toFront: cell.overlayView)
            case  .subscription:
                cell.configureCell(with: model, withTime: 0, mode: .done)
            }
        }
    }
}
