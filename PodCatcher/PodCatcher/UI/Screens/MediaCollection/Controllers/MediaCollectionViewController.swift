import UIKit

class MediaCollectionViewController: BaseCollectionViewController {
    
    // MARK: - Properties
    
    weak var delegate: MediaControllerDelegate?
    var dataSource: MediaCollectionDataSource
    
    // MARK: - UI Properties
    
    var buttonItem: UIBarButtonItem!
    var emptyView = EmptyView(frame: UIScreen.main.bounds)
    
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
            navigationItem.setRightBarButton(buttonItem, animated: false)
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
        view.addSubview(emptyView)
        collectionViewConfiguration()
        title = "Podcasts"
        collectionView.setupBackground(frame: view.bounds)
        guard let background = collectionView.backgroundView else { return }
        CALayer.createGradientLayer(with: [UIColor.gray.cgColor, UIColor.darkGray.cgColor],
                                    layer: background.layer,
                                    bounds: collectionView.bounds)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}
