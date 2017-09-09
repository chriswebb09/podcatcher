import UIKit
import CoreData

class HomeViewController: BaseCollectionViewController {
    
    // MARK: - Properties
    
    weak var coordinator: HomeCoordinator?
    
    var mode: HomeInteractionMode = .subscription
    
    private var loadingPop = LoadingPopover()
    
    weak var delegate: HomeViewControllerDelegate?
    
    var managedContext: NSManagedObjectContext!
    
    lazy var fetchedResultsController:NSFetchedResultsController<Subscription> = {
        let fetchRequest: NSFetchRequest<Subscription> = Subscription.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "feedUrl", ascending: true)]
        var controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedContext, sectionNameKeyPath: nil, cacheName: nil)
        try! controller.performFetch()
        return controller
    }()
    
    private var homeDataSource: CollectionViewDataSource<HomeViewController>!
    
    var persistentContainer: NSPersistentContainer = {
        let  persistentContainer = NSPersistentContainer(name: "PodCatcher")
        return persistentContainer
    }()
    
    // MARK: - UI Properties
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(collectionView: UICollectionView, dataSource: BaseMediaControllerDataSource) {
        self.init()
        self.collectionView = collectionView
    }
    
    func setupDataSource() {
        homeDataSource = CollectionViewDataSource(collectionView: collectionView, identifier: SubscribedPodcastCell.reuseIdentifier, fetchedResultsController: fetchedResultsController, delegate: self)
        fetchedResultsController.delegate = homeDataSource
        homeDataSource.reloadData()
        collectionView.dataSource = homeDataSource
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
        setupNavbar()
    }
    
    func initialize() {
        rightButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(changeMode))
        coordinator?.viewDidLoad(self)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    private func setupNavbar() {
        DispatchQueue.main.async {
            let backImage = #imageLiteral(resourceName: "back").withRenderingMode(.alwaysTemplate)
            self.navigationController?.navigationBar.backIndicatorImage = backImage
            self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = backImage
        }
    }    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.topItem?.title = "Subscribed Podcasts"
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
        
        let managedObjectContext = fetchedResultsController.managedObjectContext
        // Add Observer
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(managedObjectContextObjectsDidChange), name: NSNotification.Name.NSManagedObjectContextObjectsDidChange, object: managedObjectContext)
        notificationCenter.addObserver(self, selector: #selector(managedObjectContextWillSave), name: NSNotification.Name.NSManagedObjectContextWillSave, object: managedObjectContext)
        notificationCenter.addObserver(self, selector: #selector(managedObjectContextDidSave), name: NSNotification.Name.NSManagedObjectContextDidSave, object: managedObjectContext)
        
    }
    
    @objc func managedObjectContextObjectsDidChange(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        
        if let inserts = userInfo[NSInsertedObjectsKey] as? Set<NSManagedObject>, inserts.count > 0 {
            print("inserts")
        }
        
        if let updates = userInfo[NSUpdatedObjectsKey] as? Set<NSManagedObject>, updates.count > 0 {
            print("updates")
        }
        
        if let deletes = userInfo[NSDeletedObjectsKey] as? Set<NSManagedObject>, deletes.count > 0 {
            print("deletes")
        }
    }
    
    func loading() {
        DispatchQueue.main.async {
            self.showLoadingView(loadingPop: self.loadingPop)
        }
    }
    
    func finishLoading() {
        DispatchQueue.main.async {
            self.hideLoadingView(loadingPop: self.loadingPop)
        }
    }

    
    @objc func managedObjectContextWillSave(notification: NSNotification) {
        print(notification.name)
    }
    
    @objc func  managedObjectContextDidSave(notification: NSNotification) {
        print(notification.name)
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

extension HomeViewController: UICollectionViewDelegate, ErrorPresenting, LoadingPresenting {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        let item = homeDataSource.fetchedResultsController.object(at: indexPath)
        switch mode {
        case .subscription:
            let cell = cell as! SubscribedPodcastCell
           // SpinAnimation.animate(from: cell, with: 2, completion: nil)
            var caster = CasterSearchResult()
            caster.feedUrl = item.feedUrl
            guard let imageData = item.artworkImage, let image = UIImage(data: imageData as Data) else { return }
            delegate?.didSelect(at: indexPath.row, with: item, image: image, imageView: cell.getAlbumImageView())
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
            presentError(title: "Error", message: error.localizedDescription)
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
                cell.showOverlay()
            case  .subscription:
                cell.configureCell(with: model, withTime: 0, mode: .done)
            }
        }
    }
}
