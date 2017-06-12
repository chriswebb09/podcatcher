import UIKit

class PodcastListViewController: UIViewController {
    
    var dataSource: BaseMediaControllerDataSource!
    var state: PodcasterControlState = .toCollection
    weak var delegate: PodcastListViewControllerDelegate?
    var caster: Caster!
    var menuActive: MenuActive = .none
    let entryPop = EntryPopover()
    var collectionView : UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
    var topView = PodcastListTopView()
    var menuPop = BottomMenuPopover()
    var leftButtonItem: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupTopView()
        navigationItem.rightBarButtonItem?.title = "Podcasts"
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

extension PodcastListViewController: PodcastCollectionViewProtocol {

    func setup() {
        edgesForExtendedLayout = []
        setup(dataSource: self, delegate: self)
        setupNavigationController()
    }
    
    func setupTopView() {
        topView.frame = CGRect(x: 0, y: 0, width: PodcastListConstants.topFrameWidth, height: PodcastListConstants.topFrameHeight / 1.5)
        topView.podcastImageView.image = caster.artwork
        title = caster.name
        topView.delegate = self
        topView.layoutSubviews()
        view.addSubview(topView)
        collectionView.frame = CGRect(x: topView.bounds.minX, y: topView.frame.maxY, width: PodcastListConstants.topFrameWidth, height: PodcastListConstants.topFrameHeight)
        view.addSubview(collectionView)
        guard let user = dataSource.user else { return }
        topView.genreLabel.text = user.customGenres[0]
        topView.podcastTitleLabel.text = dataSource.user?.customGenres[0]
        topView.playCountLabel.text = String(describing: dataSource.user?.totalTimeListening)
    }
}
