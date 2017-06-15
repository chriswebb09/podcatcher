import UIKit

class PodcastListViewController: UIViewController {
    
    var dataSource: BaseMediaControllerDataSource
    var state: PodcasterControlState = .toCollection
    weak var delegate: PodcastListViewControllerDelegate?
    var caster: Caster!
    var index: Int
    var menuActive: MenuActive = .none
    let entryPop = EntryPopover()
    var collectionView : UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
    var topView = PodcastListTopView()
    var menuPop = BottomMenuPopover()
    var leftButtonItem: UIBarButtonItem!
    
    init(index: Int, dataSource: BaseMediaControllerDataSource) {
        self.index = index
        self.dataSource = dataSource
        
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        configureTopView()
        caster.tags = ["Test one", "test two"]
        navigationItem.rightBarButtonItem?.title = "Podcasts"
        if dataSource.user == nil {
            topView.preferencesView.moreMenuButton.isHidden = true
        }
        title = caster.name
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
        tabBarController?.tabBar.alpha = 1
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        switch state {
        case .toCollection:
            navigationController?.popViewController(animated: animated)
        case .toPlayer:
            break
        }
    }
}
