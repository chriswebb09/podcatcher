import UIKit
import CoreData

class HomeViewController: BaseCollectionViewController {
    
    // MARK: - Properties
    
    let userID: String = "none"
    var mode: HomeInteractionMode = .subscription
    weak var delegate: HomeViewControllerDelegate?
    
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
    
    var homeDataSource: CollectionViewDataSource<HomeViewController>!
    var contentState: ContentState = .empty
    
    var persistentContainer: NSPersistentContainer = {
        let  persistentContainer = NSPersistentContainer(name: "PodCatcher")
        return persistentContainer
    }()
    
    // MARK: - UI Properties
    
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
        let newLayout = HomeItemsFlowLayout()
        newLayout.setup()
        //informationView.frame = UIScreen.main.bounds
       // browseViewController.view = informationView
        //browseViewController.view.layoutSubviews()
        emptyView = InformationView(data: "Subscribe to your favorite podcasts!", icon:  #imageLiteral(resourceName: "mic-icon"))
        emptyView.setLabel(text: "Subscribe to your favorite podcasts!")
        emptyView.setIcon(icon: #imageLiteral(resourceName: "mic-icon"))
        emptyView.frame = view.frame
        
        
        emptyView.layoutSubviews()
        collectionView.collectionViewLayout = newLayout
        collectionView.frame = UIScreen.main.bounds
        collectionView.register(SubscribedPodcastCell.self)
        collectionView.setupBackground(frame: view.bounds)
        guard let background = collectionView.backgroundView else { return }
        CALayer.createGradientLayer(with: [UIColor.white.cgColor, UIColor.darkGray.cgColor], layer: background.layer, bounds: collectionView.bounds)
        rightButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(changeMode))
        rightButtonItem.tintColor = .white
        navigationItem.setRightBarButton(rightButtonItem, animated: false)
        homeDataSource = CollectionViewDataSource(collectionView: collectionView, identifier: SubscribedPodcastCell.reuseIdentifier, fetchedResultsController: fetchedResultsController, delegate: self)
        fetchedResultsController.delegate = homeDataSource
        homeDataSource.reloadData()
        collectionView.dataSource = homeDataSource
        collectionView.delegate = self
        homeDataSource.backgroundView.backgroundColor = .lightGray
        view.bringSubview(toFront: collectionView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.topItem?.title = "Subscribed Podcasts"
        homeDataSource.reloadData()
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
        if homeDataSource.itemCount == 0 {
            DispatchQueue.main.async {
                self.mode = .subscription
                self.rightButtonItem.title = "Edit"
                self.navigationItem.rightBarButtonItem = nil
            }
        } else if homeDataSource.itemCount > 0 {
            DispatchQueue.main.async {
                self.navigationItem.setRightBarButton(self.rightButtonItem, animated: false)
            }
        }
    }
}

extension HomeViewController: UIScrollViewDelegate, CollectionViewProtocol {
    
    @objc func changeMode() {
        mode = mode == .edit ? .subscription : .edit
        rightButtonItem.title = mode == .edit ? "Done" : "Edit"
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}

extension HomeViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        let item = homeDataSource.fetchedResultsController.object(at: indexPath)
        switch mode {
        case .subscription:
            guard let cell = cell else { return }
            SpinAnimation.animate(from: cell, with: 2, completion: nil)
            var caster = CasterSearchResult()
            caster.feedUrl = item.feedUrl
            guard let imageData = item.artworkImage, let image = UIImage(data: imageData as Data) else { return }
            delegate?.didSelect(at: indexPath.row, with: item, image: image)
        case .edit:
            update(indexPath: indexPath, item: item)
        }
    }
    
    func remove(for indexPath: IndexPath) {
        do {
            try self.homeDataSource.fetchedResultsController.performFetch()
            let feed = self.homeDataSource.fetchedResultsController.object(at: indexPath).feedUrl
            self.managedContext.delete(self.homeDataSource.fetchedResultsController.object(at: indexPath))
            var subscriptions = UserDefaults.loadSubscriptions()
            guard let feedUrl = feed else { return }
            if let index = subscriptions.index(of: feedUrl) {
                subscriptions.remove(at: index)
                UserDefaults.saveSubscriptions(subscriptions: subscriptions)
            }
            do {
                try self.managedContext.save()
                self.homeDataSource.reloadData()
                if self.homeDataSource.itemCount == 0 {
                    DispatchQueue.main.async {
                        self.mode = .subscription
                        self.rightButtonItem.title = "Edit"
                        self.navigationItem.rightBarButtonItem = nil
                    }
                }
            }
        } catch let error {
            presentAlert(message: error.localizedDescription)
        }
    }
    
    func update(indexPath: IndexPath, item: Subscription) {
        guard let podcastTitle = item.podcastTitle else { return }
        let message = "Pressing okay will remove: \n \(podcastTitle) \n from your subscription list."
        let actionSheetController: UIAlertController = UIAlertController(title: "Are you sure?", message: message, preferredStyle: .alert)
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action in
            actionSheetController.dismiss(animated: false, completion: nil)
        }
        let okayAction: UIAlertAction =  UIAlertAction(title: "Okay", style: .destructive) { action in
            self.remove(for: indexPath)
        }
        actionSheetController.addAction(cancelAction)
        actionSheetController.addAction(okayAction)
        self.present(actionSheetController, animated: true, completion: nil)
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
