import UIKit

@objc class MediaCollectionViewController: BaseCollectionViewController {
    
    // MARK: - Properties
    
    weak var delegate: MediaControllerDelegate?
    var dataSource: MediaCollectionDataSource
     var sideMenuPop = SideMenuPopover()
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
        let mediaDataSource = MediaCollectionDataSource(casters: dataSource.casters)
        self.dataSource = mediaDataSource
        self.viewShown = self.dataSource.viewShown
        super.init(nibName: nil, bundle: nil)
        if dataSource.user != nil {
            rightButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "menu-red"), style: .done, target: self, action: #selector(popMenu))
            navigationItem.setRightBarButton(rightButtonItem, animated: false)
            leftButtonItem = UIBarButtonItem(title: "Log Out", style: .done, target: self, action: #selector(logout))
            leftButtonItem.setTitleTextAttributes(MediaCollectionConstants.stringAttributes, for: .normal)
            navigationItem.setLeftBarButton(leftButtonItem, animated: false)
        }
    }
    
    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(collectionView: UICollectionView, dataSource: BaseMediaControllerDataSource) {
        self.init(dataSource: dataSource)
        self.collectionView = collectionView
    }
    
    func menu() {
        print("menu")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionViewConfiguration()
        title = "Podcasts"
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
    
    dynamic func popMenu() {
        // sideMenuPop.popView.delegate = self
        sideMenuPop.setupPop()
        showSideMenu()
        dump(sideMenuPop)
        
    }
    
    dynamic func hideSideMenu() {
        // menuActive = .hidden
        sideMenuPop.hideMenu(controller: self)
    }
    
    dynamic func showSideMenu() {
        hideKeyboardWhenTappedAround()
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideSideMenu))
        view.addGestureRecognizer(tap)
        collectionView.addGestureRecognizer(tap)
        //  topView.addGestureRecognizer(tap)
        UIView.animate(withDuration: 0.15) {
            self.sideMenuPop.showPopView(viewController: self)
            self.sideMenuPop.popView.isHidden = false
        }
    }

}
