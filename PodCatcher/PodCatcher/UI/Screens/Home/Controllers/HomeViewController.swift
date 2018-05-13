import UIKit
import CoreData

class HomeViewController: BaseCollectionViewController {
    
    // MARK: - Properties
    
    weak var coordinator: HomeCoordinator?
    
    var mode: HomeInteractionMode = .subscription
    
    private var loadingPop = LoadingPopover()
    
    weak var delegate: HomeViewControllerDelegate?
    var managedContext: NSManagedObjectContext!
    
    var podcasters: [Podcaster] = []
    
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Podcaster")
    
    var fetchedResultsController:NSFetchedResultsController<Podcaster>!
    
    var persistentContainer: NSPersistentContainer!
    
    var homeDataSource: CollectionViewDataSource<HomeViewController>!
    
    // MARK: - UI Properties
    
    init() {
        super.init(nibName: nil, bundle: nil)
        // self.homeDataSource.fetchedResultsController = fetchedResultsController
        //  self.homeDataSource.managedContext = managedContext
    }
    
    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(collectionView: UICollectionView, dataSource: BaseMediaControllerDataSource) {
        self.init()
        self.collectionView = collectionView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
        setupNavbar()
        edgesForExtendedLayout = []
        collectionView.collectionViewLayout.invalidateLayout()
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
    
    private func setupAutoresizingMasks() {
        view.autoresizingMask = []
        collectionView.autoresizingMask = []
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        view.layoutSubviews()
        setupAutoresizingMasks()
        let font = UIFont(name: "AvenirNext-Regular", size: 16)!
        
        navigationController?.navigationBar.topItem?.title = "Subscribed Podcasts"
        edgesForExtendedLayout = []
        
        if homeDataSource.itemCount == 0 {
            DispatchQueue.main.async {
                self.mode = .subscription
                self.rightButtonItem.title = "Edit"
                self.navigationItem.rightBarButtonItem = nil
                self.rightButtonItem.setTitleTextAttributes([NSAttributedStringKey.font: font,
                                                             NSAttributedStringKey.foregroundColor: UIColor.white], for: .normal)
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
        
        DispatchQueue.main.async {
            self.collectionView.translatesAutoresizingMaskIntoConstraints = false
            self.collectionView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 8).isActive = true
            self.collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
            self.collectionView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1).isActive = true
            self.collectionView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
            self.collectionView.register(SubscribedPodcastCell.self)
            self.collectionView.layoutIfNeeded()
        }
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        // needed to clear the text in the back navigation:
        self.navigationItem.title = " "
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
    
    @objc func managedObjectContextDidSave(notification: NSNotification) {
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
            let cell = cell as! SubscriptionCell
            guard let imageData = item.podcastArtworkImage, let image = UIImage(data: imageData as Data) else { return }
            let imageView = cell.getAlbumImageView()
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 5, options: [],
                           animations: {
                            cell.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                            
            }) { finished in
                UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 5, options: .curveEaseInOut,
                               animations: {
                                cell.transform = CGAffineTransform(scaleX: 1, y: 1)
                }, completion: nil)
            }
            delegate?.selectedItem(at: indexPath.row, podcast: item, imageView: imageView)
        case .edit:
            print("edit")
        }
    }
    
    func remove(for indexPath: IndexPath) {
        do {
            try self.homeDataSource.fetchedResultsController.performFetch()
            let feed = self.homeDataSource.fetchedResultsController.object(at: indexPath).feedUrl
            self.persistentContainer.viewContext.delete(self.homeDataSource.fetchedResultsController.object(at: indexPath))
            var subscriptions = UserDefaults.loadSubscriptions()
            guard let feedUrl = feed else { return }
            if let index = subscriptions.index(of: feedUrl) {
                subscriptions.remove(at: index)
                UserDefaults.saveSubscriptions(subscriptions: subscriptions)
            }
            do {
                try self.persistentContainer.viewContext.save()
                self.homeDataSource.reloadData()
                if self.homeDataSource.itemCount == 0 {
                    DispatchQueue.main.async {
                        self.mode = .subscription
                        //self.homeDataSource.mode = .subscription
                        self.navigationItem.rightBarButtonItem = nil
                    }
                }
            }
        } catch let error {
            presentError(title: "Error", message: error.localizedDescription)
        }
    }
}

extension HomeViewController: CollectionViewDataSourceDelegate {
    
    typealias Object = Podcaster
    typealias Cell = SubscriptionCell
    
    func configure(_ cell: SubscriptionCell, for object: Podcaster) {
        if let imageData = object.podcastArtworkImage, let image = UIImage(data: imageData as Data), let title = object.podcastTitle {
            let model = SubsciptionCellViewModel(trackName: title, albumImageURL: image)
            
            switch mode {
            case .edit:
                cell.alpha = 1
                cell.configureCell(with: model, withTime: 0, mode: .edit)
                cell.showOverlay()
            case .subscription:
                cell.alpha = 1
                cell.configureCell(with: model, withTime: 0, mode: .done)
            }
        }
    }
}
