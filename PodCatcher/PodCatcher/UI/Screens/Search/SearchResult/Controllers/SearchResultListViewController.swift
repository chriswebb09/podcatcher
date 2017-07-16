import UIKit

class SearchResultListViewController: BaseCollectionViewController {
    
    var item: CasterSearchResult!
    var state: PodcasterControlState = .toCollection
    var searchResults = ConfirmationIndicatorView()
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
        navigationController?.navigationBar.backIndicatorImage = backImage
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = backImage
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.navigationBar.alpha = 1
        if let item = item, let title = item.podcastTitle {
            navigationController?.navigationBar.topItem?.title = title
            navigationController?.navigationBar.backItem?.title = ""
        }
        let subscription = UserDefaults.loadSubscriptions()
        if let item = item, let feedUrl = item.feedUrl, !subscription.contains(feedUrl) {
            rightButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(subscribeToFeed))
            navigationItem.setRightBarButton(rightButtonItem, animated: false)
            rightButtonItem.tintColor = .white
        }
        topView.preferencesView.moreMenuButton.isHidden = true
        navigationController?.navigationBar.backItem?.title = ""
    }
    
    func saveFeed() {
        let feedStore = FeedCoreDataStack()
        guard let title = item.podcastTitle else { return }
        guard let image = topView.podcastImageView.image else { return }
        if let user = dataSource.user {
            print(user)
            dump(user.userId)
            feedStore.save(feedUrl: item.feedUrlString, podcastTitle: title, episodeCount: episodes.count, lastUpdate: NSDate(), image: image, uid: user.userId)
        } else {
            feedStore.save(feedUrl: item.feedUrlString, podcastTitle: title, episodeCount: episodes.count, lastUpdate: NSDate(), image: image, uid: "none")
        }
        
        var subscriptions = UserDefaults.loadSubscriptions()
        subscriptions.append(item.feedUrl!)
        UserDefaults.saveSubscriptions(subscriptions: subscriptions)
        navigationItem.rightBarButtonItem = nil
    }
    
    func subscribeToFeed() {
        saveFeed()
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.2) {
                self.searchResults.showActivityIndicator(viewController: self)
            }
            UIView.animate(withDuration: 1, animations: {
                self.searchResults.loadingView.alpha = 0
            }, completion: { finished in
                self.searchResults.hideActivityIndicator(viewController: self)
            })
        }
    }
    
    func navigateBack() {
        collectionView.alpha = 0
        dismiss(animated: false, completion: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(false)
        switch state {
        case .toCollection:
            dismiss(animated: false, completion: nil)
        case .toPlayer:
            break
        }
    }
}
