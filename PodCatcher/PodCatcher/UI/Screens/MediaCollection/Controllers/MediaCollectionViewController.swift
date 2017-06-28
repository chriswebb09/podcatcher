import UIKit

class MediaCollectionViewController: BaseCollectionViewController {
    
    // MARK: - Properties
    
    weak var delegate: MediaControllerDelegate?
    var dataSource: MediaCollectionDataSource
    
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
        let mediaDataSource = MediaCollectionDataSource(casters: dataSource.casters)
        self.dataSource = mediaDataSource
        self.viewShown = self.dataSource.viewShown
        super.init(nibName: nil, bundle: nil)
        
        if dataSource.user != nil {
            buttonItem = UIBarButtonItem(title: "Log Out", style: .done, target: self, action: #selector(logout))
            buttonItem.setTitleTextAttributes(MediaCollectionConstants.stringAttributes, for: .normal)
            rightButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "menu-red"), style: .done, target: self, action: #selector(popBottomMenu(popped:)))
            navigationItem.setRightBarButton(rightButtonItem, animated: false)
            navigationItem.setLeftBarButton(buttonItem, animated: false)
        }
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
        collectionViewConfiguration()
        title = "Podcasts"
        collectionView.setupBackground(frame: view.bounds)
        guard let background = collectionView.backgroundView else { return }
    }
    
    func popBottomMenu(popped: Bool) {
        sideMenuPop.setupPop()
        showMenu()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
    }
}

