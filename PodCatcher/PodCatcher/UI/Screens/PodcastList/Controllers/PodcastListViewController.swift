import UIKit

class PodcastListViewController: BaseCollectionViewController {
    
    var dataSource: PodcastListDataSource
    var state: PodcasterControlState = .toCollection
    weak var delegate: PodcastListViewControllerDelegate?
    
    var menuActive: MenuActive = .none
    let entryPop = EntryPopover()
    var topView = PodcastListTopView()
    var menuPop = BottomMenuPopover()
    
    init(index: Int, dataSource: BaseMediaControllerDataSource) {
        var podcastListDataSource = PodcastListDataSource(casters: dataSource.casters)
        podcastListDataSource.index = index
        podcastListDataSource.caster = dataSource.casters[index]
        self.dataSource = podcastListDataSource
        super.init(nibName: nil, bundle: nil)
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
        view.sendSubview(toBack: background)
        if let user = dataSource.user {
            title = dataSource.caster.name
            let timeString = String(describing: user.totalTimeListening)
            topView.configure(tags: [], timeListen: timeString)
        } else {
            topView.preferencesView.moreMenuButton.isHidden = true
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
