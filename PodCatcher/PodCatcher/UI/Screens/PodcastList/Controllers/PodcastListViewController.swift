import UIKit

class PodcastListViewController: UIViewController {
    
    let entryPop = EntryPopover()
    
    var collectionView : UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
    var topView = PodcastListTopView()
    var dataSource: BaseMediaControllerDataSource!
    var state: PodcasterControlState = .toCollection
    var menuPop = BottomMenuPopover()
    weak var delegate: PodcastListViewControllerDelegate?
    var caster: Caster!
    var menuActive: MenuActive = .none
    var leftButtonItem: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupTopView()
    }
    
    func setup() {
        edgesForExtendedLayout = []
        collectionView.dataSource = self
        collectionView.delegate = self
        setupNavigationController()
        collectionView.register(PodcastCell.self)
        collectionView.backgroundColor = PodcastListConstants.backgroundColor
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

// MARK: - UIScrollViewDelegate

extension PodcastListViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset
        if offset.y > PodcastListConstants.minimumOffset {
            UIView.animate(withDuration: 1) {
                print(offset.y)
                self.topView.removeFromSuperview()
                self.collectionView.frame = self.view.bounds
            }
        } else {
            UIView.animate(withDuration: 0.5) {
                let topFrameHeight = self.view.bounds.height / 2
                let topFrameWidth = self.view.bounds.width
                self.topView.frame = CGRect(x: 0, y: 0, width: topFrameWidth, height: topFrameHeight / 1.5)
                self.topView.podcastImageView.image = self.caster.artwork
                self.topView.layoutSubviews()
                self.view.addSubview(self.topView)
                self.collectionView.frame = CGRect(x: self.topView.bounds.minX, y: self.topView.frame.maxY, width: topFrameWidth, height: self.view.bounds.height)
            }
        }
    }
}


