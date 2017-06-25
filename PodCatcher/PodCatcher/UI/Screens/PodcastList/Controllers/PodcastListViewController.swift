import UIKit

class PodcastListViewController: BaseCollectionViewController {
    
    var dataSource: PodcastListDataSource
    
    var state: PodcasterControlState = .toCollection
    
    weak var delegate: PodcastListViewControllerDelegate?
    
    var menuActive: MenuActive = .none
    let entryPop = EntryPopover()
    var topView = PodcastListTopView()
    var menuPop = BottomMenuPopover()
    
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
    
    init(index: Int, dataSource: BaseMediaControllerDataSource) {
        let podcastListDataSource = PodcastListDataSource(casters: dataSource.casters)
        podcastListDataSource.index = index
        podcastListDataSource.caster = dataSource.casters[index]
        self.dataSource = podcastListDataSource
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
        topView.delegate = self
        view.sendSubview(toBack: background)
        if let user = dataSource.user {
            title = dataSource.caster.name
            let timeString = String(describing: user.totalTimeListening)
            topView.configure(tags: [], timeListen: timeString)
        } else {
            
            title = "Podcast"
        }
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
