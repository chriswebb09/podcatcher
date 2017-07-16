import UIKit
import CoreData

enum HomeInteractionMode {
    case subscription, edit
}

class HomeViewController: BaseCollectionViewController {
    
    // MARK: - Properties
    
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
       // view.backgroundColor = UIColor(red:0.32, green:0.13, blue:0.70, alpha:1.0)
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
