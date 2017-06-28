import UIKit

class SearchResultListViewController: BaseCollectionViewController {
    
    var item: CasterSearchResult!
    var state: PodcasterControlState = .toCollection
    
    weak var delegate: PodcastListViewControllerDelegate?
    
    var newItems = [[String : String]]()
    var menuActive: MenuActive = .none
    let entryPop = EntryPopover()
    var topView = PodcastListTopView()
    var menuPop = BottomMenuPopover()
    var sideMenuPop = SideMenuPopover()

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
    
    init(index: Int) {
        self.viewShown = .collection
        super.init(nibName: nil, bundle: nil)
        self.topView.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup(dataSource: self, delegate: self)
        configureTopView()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "plus-red"), style: .plain, target: self, action: #selector(hidePop))
        background.frame = view.frame
        view.addSubview(background)
        emptyView.alpha = 0
        edgesForExtendedLayout = []
        topView.delegate = self
        view.sendSubview(toBack: background)
        collectionView.register(PodcastResultCell.self)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        switch state {
        case .toCollection:
            navigationController?.popViewController(animated: false)
        case .toPlayer:
            break
        }
    }
}
