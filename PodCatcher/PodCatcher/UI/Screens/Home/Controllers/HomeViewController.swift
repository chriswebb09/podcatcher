import UIKit
import CoreData

class HomeViewController: BaseCollectionViewController {
    
    // MARK: - Properties
    
    weak var delegate: HomeViewControllerDelegate?
    var dataSource: HomeDataSource
    var items = [Subscription]()
    var fetchedResultsController:NSFetchedResultsController<Subscription>!
    let persistentContainer = NSPersistentContainer(name: "PodCatcher")
   
    // MARK: - UI Properties
    
    var buttonItem: UIBarButtonItem!
    
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
        title = "Podcasts"
        collectionView.delegate = self
        collectionView.register(SubscribedPodcastCell)
        collectionView.dataSource = self
        collectionView.setupBackground(frame: view.bounds)
        guard let background = collectionView.backgroundView else { return }
        CALayer.createGradientLayer(with: [UIColor.gray.cgColor, UIColor.darkGray.cgColor], layer: background.layer, bounds: collectionView.bounds)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadData()
        tabBarController?.tabBar.isHidden = false
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
}
