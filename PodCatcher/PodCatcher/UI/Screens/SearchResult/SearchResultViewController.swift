import UIKit

class SearchResultListViewController: BaseCollectionViewController {
    
    var item: CasterSearchResult!
    var state: PodcasterControlState = .toCollection
    var dataSource: BaseMediaControllerDataSource!
    weak var delegate: PodcastListViewControllerDelegate?
    var episodes = [Episodes]()
    var newItems = [[String : String]]()
    var menuActive: MenuActive = .none
    let entryPop = EntryPopover()
    var topView = PodcastListTopView()
    var feedUrl: String!
    var bottomMenu = BottomMenu()

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
        bottomMenu.setMenu(color: .mainColor, borderColor: .darkGray, textColor: .white)
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
    
    func moreButton(tapped: Bool) {
        let height = view.bounds.height * 0.5
        let width = view.bounds.width
        let size = CGSize(width: width, height: height)
        let originX = view.bounds.width * 0.001
        let originY = view.bounds.height * 0.6
        let origin = CGPoint(x: originX, y: originY)
        bottomMenu.menu.delegate = self
        bottomMenu.setMenu(size)
        bottomMenu.setMenu(origin)
        bottomMenu.setupMenu()
        bottomMenu.setMenu(color: .white, borderColor: .darkGray, textColor: .darkGray)
        showPopMenu()
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
