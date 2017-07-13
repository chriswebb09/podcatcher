import UIKit

class SearchResultListViewController: BaseCollectionViewController {
    
    var item: CasterSearchResult!
    var state: PodcasterControlState = .toCollection
    
    var dataSource: BaseMediaControllerDataSource!
    
    weak var delegate: PodcastListViewControllerDelegate?
    var currentPlaylistID: String = ""
    var episodes = [Episodes]()
    var newItems = [[String : String]]()
    var menuActive: MenuActive = .none
    let entryPop = EntryPopover()
    var topView = ListTopView()
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
        viewShown = .collection
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup(dataSource: self, delegate: self)
        configureTopView()
        background.frame = view.frame
        view.addSubview(background)
        emptyView.alpha = 0
        edgesForExtendedLayout = []
        view.sendSubview(toBack: background)
        collectionView.register(PodcastResultCell.self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        collectionView.alpha = 1
        let backImage = #imageLiteral(resourceName: "back").withRenderingMode(.alwaysTemplate)
        self.navigationController?.navigationBar.backIndicatorImage = backImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = backImage
        self.navigationController?.navigationBar.backItem?.title = ""
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.navigationBar.alpha = 1
        let  plusImage = #imageLiteral(resourceName: "plus-red").withRenderingMode(.alwaysTemplate)
        rightButtonItem = UIBarButtonItem(title: "Subscribe", style: .plain, target: self, action: #selector(subscribeToFeed))
      //  rightButtonItem = UIBarButtonItem(image: plusImage, style: .done, target: self, action: #selector(subscribeToFeed))
        navigationItem.setRightBarButton(rightButtonItem, animated: false)
        rightButtonItem.tintColor = .white
    }
    
    func subscribeToFeed() {
        let feedStore = FeedCoreDataStack()
        guard let title = item.podcastTitle else { return }
        guard let image = topView.podcastImageView.image else { return }
        feedStore.save(feedUrl: item.feedUrlString, podcastTitle: title, episodeCount: episodes.count, lastUpdate: NSDate(), image: image)
    }
    
    func navigateBack() {
        navigationController?.popViewController(animated: false)
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
