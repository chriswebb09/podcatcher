import UIKit

class MediaCollectionViewController: BaseCollectionViewController {
    
    // MARK: - Properties
    
    weak var delegate: MediaControllerDelegate?
    var dataSource: MediaCollectionDataSource
    
    var sideMenuPop = SideMenuPopover()
    
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
        CALayer.createGradientLayer(with: [UIColor.gray.cgColor, UIColor.darkGray.cgColor],
                                    layer: background.layer,
                                    bounds: collectionView.bounds)
    }
    
    func showMenu() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideMenu))
        view.addGestureRecognizer(tap)
        collectionView.addGestureRecognizer(tap)
        rightButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "menu-red"), style: .done, target: self, action: #selector(hideMenu))
        navigationItem.setRightBarButton(rightButtonItem, animated: false)

        UIView.animate(withDuration: 0.15) {
            self.sideMenuPop.showPopView(viewController: self)
            self.sideMenuPop.popView.isHidden = false
        }
    }
    
    func popBottomMenu(popped: Bool) {
        sideMenuPop.setupPop()
        showMenu()
    }
    
    func hideMenu() {
        sideMenuPop.hideMenu(controller: self)
        rightButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "menu-red"), style: .done, target: self, action: #selector(popBottomMenu(popped:)))
        navigationItem.setRightBarButton(rightButtonItem, animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
    }
}

