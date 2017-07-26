import UIKit
import CoreData

protocol HomeViewControllerDelegate: class {
    func didSelect(at index: Int, with caster: PodcastSearchResult, image: UIImage)
    func didSelect(at index: Int, with subscription: Subscription, image: UIImage)
    func logout(tapped: Bool)
}

enum HomeInteractionMode {
    case subscription, edit
}

class HomeItemsFlowLayout: UICollectionViewFlowLayout {
    func setup() {
        scrollDirection = .vertical
        itemSize = CGSize(width: UIScreen.main.bounds.width / 3.4, height: UIScreen.main.bounds.height / 7)
        sectionInset = UIEdgeInsets(top: 5, left: 10, bottom: 0, right: 10)
        minimumLineSpacing = 15
    }
}

class HomeViewController: BaseCollectionViewController {
    
    // MARK: - Properties
    
    let userID: String = "none"
    var mode: HomeInteractionMode = .subscription
    weak var delegate: HomeViewControllerDelegate?
    var dataSource: HomeDataSource
    var items = [Subscription]()
    var fetchedResultsController:NSFetchedResultsController<Subscription>!
    let persistentContainer = NSPersistentContainer(name: "PodCatcher")
    
    // MARK: - UI Properties
    
    var viewShown: ShowView {
        didSet {
            switch viewShown {
            case .empty:
                changeView(forView: emptyView, withView: collectionView)
            case .collection:
                changeView(forView: collectionView, withView: emptyView)
            }
        }
    }
    
    init(dataSource: BaseMediaControllerDataSource) {
        let homeDataSource = HomeDataSource()
        self.dataSource = homeDataSource
        self.viewShown = .empty
        super.init(nibName: nil, bundle: nil)
        view.addSubview(emptyView)
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
        reloadData()
        collectionViewConfiguration()
        setupCollectionView(view: view, newLayout: HomeItemsFlowLayout())
        collectionView.delegate = self
        collectionView.register(SubscribedPodcastCell.self)
        collectionView.dataSource = self
        collectionView.setupBackground(frame: view.bounds)
        guard let background = collectionView.backgroundView else { return }
        CALayer.createGradientLayer(with: [UIColor.white.cgColor, UIColor.darkGray.cgColor], layer: background.layer, bounds: collectionView.bounds)
        rightButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(changeMode))
        rightButtonItem.tintColor = .white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadData()
        tabBarController?.tabBar.isHidden = false
        navigationController?.navigationBar.topItem?.title = "Subscribed Podcasts"
    }
    
    func setup(with newLayout: HomeItemsFlowLayout) {
        newLayout.setup()
        collectionView.collectionViewLayout = newLayout
        collectionView.frame = UIScreen.main.bounds
    }
    
    func setupCollectionView(view: UIView, newLayout: HomeItemsFlowLayout) {
        setup(with: newLayout)
        collectionView.frame = UIScreen.main.bounds
    }
    
    func changeMode() {
        mode = mode == .edit ? .subscription : .edit
        rightButtonItem.title = mode == .edit ? "Done" : "Edit"
        collectionView.reloadData()
    }
}

extension HomeViewController: UICollectionViewDelegate {
    
    func logoutTapped() {
        delegate?.logout(tapped: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch mode {
        case .subscription:
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
                guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
                let context = appDelegate.persistentContainer.viewContext
                let feed = self.fetchedResultsController.object(at: indexPath).feedUrl
                context.delete(self.fetchedResultsController.object(at: indexPath))
                var subscriptions = UserDefaults.loadSubscriptions()
                if let index = subscriptions.index(of: feed!) {
                    subscriptions.remove(at: index)
                    UserDefaults.saveSubscriptions(subscriptions: subscriptions)
                }
                self.reloadData()
                do {
                    try context.save()
                } catch let error {
                    self.showError(errorString: " \(error.localizedDescription)")
                    print("Unable to Perform Fetch Request \(error), \(error.localizedDescription)")
                }
            }
            
            actionSheetController.addAction(cancelAction)
            actionSheetController.addAction(okayAction)
            self.present(actionSheetController, animated: true, completion: nil)
            
            if let count = fetchedResultsController.fetchedObjects?.count {
                if count == 0 {
                    mode = .subscription
                    rightButtonItem.title = "Edit"
                }
            }
        }
    }
    
    func showError(errorString: String) {
        let actionSheetController: UIAlertController = UIAlertController(title: "Error", message: errorString, preferredStyle: .alert)
        let okayAction: UIAlertAction =  UIAlertAction(title: "Okay", style: .cancel) { action in
            actionSheetController.dismiss(animated: false, completion: nil)
        }
        actionSheetController.addAction(okayAction)
        present(actionSheetController, animated: false)
    }
}

extension HomeViewController: UIScrollViewDelegate {
    
    func collectionViewConfiguration() {
        collectionView.delegate = self
        collectionView.dataSource = dataSource
        collectionView.isPagingEnabled = true
        collectionView.isScrollEnabled = true
        collectionView.decelerationRate = UIScrollViewDecelerationRateFast
        collectionView.backgroundColor = .clear
    }
}

extension HomeViewController: NSFetchedResultsControllerDelegate {
    
    func reloadData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let fetchRequest:NSFetchRequest<Subscription> = Subscription.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "feedUrl", ascending: true)]
        fetchRequest.predicate = NSPredicate(format: "uid==%@", "none")
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: appDelegate.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
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

extension HomeViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let itemNumber = fetchedResultsController.sections?[section].numberOfObjects {
            if itemNumber > 0 {
                viewShown = .collection
                navigationItem.setRightBarButton(rightButtonItem, animated: false)
            } else if itemNumber == 0 {
                viewShown = .empty
                mode = .subscription
                rightButtonItem.title = "Edit"
                navigationItem.rightBarButtonItem = nil
            }
        }
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as SubscribedPodcastCell
        let item = fetchedResultsController.object(at: indexPath)
        if let imageData = item.artworkImage,
            let image = UIImage(data: imageData as Data),
            let title = item.podcastTitle {
            let model = SubscribedPodcastCellViewModel(trackName: title, albumImageURL: image)
            switch mode {
            case .edit:
                cell.configureCell(with: model, withTime: 0, mode: .edit)
                cell.bringSubview(toFront: cell.overlayView)
            case  .subscription:
                cell.configureCell(with: model, withTime: 0, mode: .done)
            }
        }
        return cell
    }
}
