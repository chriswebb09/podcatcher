import UIKit

struct MediaCollectionConstants {
    static let stringAttributes = [
        NSFontAttributeName: UIFont(name:"Avenir", size: 16)!,
        NSForegroundColorAttributeName: PlayerViewConstants.titleViewBackgroundColor]
}

class MediaCollectionViewController: BaseCollectionViewController {
    
    // MARK: - Properties
    
    var buttonItem: UIBarButtonItem!
    
    weak var delegate: MediaControllerDelegate?
    var emptyView = EmptyView(frame: UIScreen.main.bounds)
    
    var viewShown: ShowView = .empty {
        didSet {
            switch viewShown {
            case .empty:
                changeView(forView: emptyView, withView: collectionView)
            case .collection:
                changeView(forView: collectionView, withView: emptyView)
            }
        }
    }
    
    var dataSource: BaseMediaControllerDataSource {
        didSet {
            if dataSource.casters.count > 0 {
                viewShown = .collection
            } else {
                viewShown = .empty
            }
        }
    }
    
    init(dataSource: BaseMediaControllerDataSource) {
        self.dataSource = dataSource
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
        view.addSubview(emptyView)
        collectionViewConfiguration()
        if dataSource.user != nil {
            buttonItem = UIBarButtonItem(title: "Log Out", style: .done, target: self, action: #selector(logout))
            buttonItem.setTitleTextAttributes(MediaCollectionConstants.stringAttributes, for: .normal)
        }
        title = "Podcasts"
        navigationItem.setRightBarButton(buttonItem, animated: false)
        collectionView.setupBackground(frame: view.bounds)
        guard let background = collectionView.backgroundView else { return }
        CALayer.createGradientLayer(with: [UIColor.gray.cgColor, UIColor.darkGray.cgColor], layer: background.layer, bounds: collectionView.bounds)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}


