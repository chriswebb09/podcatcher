import UIKit

class PodcastListViewController: BaseCollectionViewController {
    
    var dataSource: BaseMediaControllerDataSource
    var state: PodcasterControlState = .toCollection
    weak var delegate: PodcastListViewControllerDelegate?
    var caster: Caster
    var menuActive: MenuActive = .none
    
    var index: Int {
        didSet {
            caster = dataSource.casters[index]
        }
    }
    
    let entryPop = EntryPopover()
    var topView = PodcastListTopView()
    var menuPop = BottomMenuPopover()
    
    init(index: Int, dataSource: BaseMediaControllerDataSource) {
        self.index = index
        self.dataSource = dataSource
        
        caster = dataSource.casters[index]
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        configureTopView()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "plus-red"), style: .plain, target: self, action: #selector(hidePop))
        background.frame = view.frame
        view.addSubview(background)
        view.sendSubview(toBack: background)
        if let user = dataSource.user {
            title = caster.name
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
            navigationController?.popViewController(animated: animated)
        case .toPlayer:
            break
        }
    }
}
