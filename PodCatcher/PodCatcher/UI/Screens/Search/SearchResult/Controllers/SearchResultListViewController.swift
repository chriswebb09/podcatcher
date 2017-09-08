import UIKit

final class SearchResultListViewController: BaseCollectionViewController {
    
    var item: CasterSearchResult!
    var state: PodcasterControlState = .toCollection
    var searchResults = ConfirmationIndicatorView()
    var dataSource: BaseMediaControllerDataSource!
    
    weak var delegate: PodcastListViewControllerDelegate?
    
    var episodes = [Episodes]()
    var menuActive: MenuActive = .none
    let entryPop = EntryPopover()
    var topView = ListTopView()
    
    var feedUrl: String!
    var bottomMenu = BottomMenu()
    
    let subscription = UserDefaults.loadSubscriptions()
    
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
        self.emptyView = InformationView(data: "No Data.", icon: #imageLiteral(resourceName: "mic-icon"))
        setup(dataSource: self, delegate: self)
        configureTopView()
        background.frame = view.frame
        view.addSubview(background)
        emptyView.alpha = 0
        edgesForExtendedLayout = []
        view.sendSubview(toBack: background)
        collectionView.register(PodcastResultCell.self)
        
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            guard let navBar = strongSelf.navigationController?.navigationBar else { return }
            strongSelf.navigationItem.titleView?.frame.center = CGPoint(x: navBar.center.x - 50, y: navBar.center.y)
            navBar.topItem?.titleView?.frame.center = CGPoint(x: navBar.center.x - 50, y: navBar.center.y)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        let backImage = #imageLiteral(resourceName: "back").withRenderingMode(.alwaysTemplate)
        navigationController?.navigationBar.backIndicatorImage = backImage
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = backImage
        
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: self, action: nil)
            strongSelf.navigationItem.backBarButtonItem = backButton
            if let item = self?.item, let title = item.podcastTitle {
                self?.navigationItem.title = title
            }
        }
        
        if let item = item, let title = item.podcastTitle {
            navigationController?.navigationBar.topItem?.title = title
            navigationController?.navigationBar.backItem?.title = ""
        }
        
        if let item = item, let feedUrl = item.feedUrl, !subscription.contains(feedUrl) {
            let button = UIButton(type: .system)
            button.setTitle("Subscribe", for: .normal)
            button.addTarget(self, action: #selector(subscribeToFeed), for: .touchUpInside)
            button.layer.borderWidth = 1
            button.layer.cornerRadius = 10
            button.layer.borderColor = UIColor.white.cgColor
            button.titleEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5)
            topView.preferencesView.moreMenuButton = button
            button.tintColor = .white
            button.backgroundColor = .darkGray
            button.alpha = 0.8
        }
        
        DispatchQueue.main.async {
            self.topView.podcastImageView.layer.cornerRadius = 4
            self.topView.podcastImageView.layer.masksToBounds = true
            self.topView.layer.setCellShadow(contentView: self.topView)
            self.topView.podcastImageView.layer.setCellShadow(contentView: self.topView.podcastImageView)
        }
        
        UIView.animate(withDuration: 0.002) { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.navigationController?.navigationBar.alpha = 1
        }
        collectionView.alpha = 1
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.navigationBar.alpha = 1
        
        let newLayout = SearchItemsFlowLayout()
        newLayout.setup()
        self.collectionView.collectionViewLayout.invalidateLayout()
        self.collectionView.collectionViewLayout = newLayout
    }
    
    func saveFeed() {
        guard let image = topView.podcastImageView.image else { return }
        delegate?.saveFeed(item: item, podcastImage: image , episodesCount: episodes.count)
        topView.preferencesView.moreMenuButton.isHidden = true
    }
    
    
    @objc func subscribeToFeed() {
        saveFeed()
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            UIView.animate(withDuration: 0.2) {
                strongSelf.searchResults.showActivityIndicator(viewController: strongSelf)
                self?.topView.preferencesView.moreMenuButton.isHidden = true
            }
            UIView.animate(withDuration: 1, animations: {
                strongSelf.searchResults.loadingView.alpha = 0
            }, completion: { finished in
                strongSelf.searchResults.hideActivityIndicator(viewController: strongSelf)
                self?.topView.preferencesView.moreMenuButton.isHidden = true
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

// MARK: - PodcastCollectionViewProtocol

extension SearchResultListViewController {
    
    func configureTopView() {
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.navigationController?.navigationBar.backItem?.title = ""
            strongSelf.navigationController?.navigationItem.backBarButtonItem?.title = ""
            strongSelf.navigationItem.backBarButtonItem?.title = ""
        }
        topView.frame = PodcastListConstants.topFrame
        if let item = item, let urlString = item.podcastArtUrlString, let url = URL(string: urlString) {
            topView.podcastImageView.downloadImage(url: url)
        }
        topView.layoutSubviews()
        view.addSubview(topView)
        view.bringSubview(toFront: topView)
        setupView()
    }
    
    func setup(dataSource: UICollectionViewDataSource, delegate: UICollectionViewDelegate) {
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.navigationController?.navigationBar.backItem?.title = ""
            strongSelf.navigationController?.navigationItem.backBarButtonItem?.title = ""
            strongSelf.navigationItem.backBarButtonItem?.title = ""
        }
        collectionView.dataSource = dataSource
        collectionView.delegate = delegate
        collectionView.register(PodcastCell.self)
        collectionView.backgroundColor = PodcastListConstants.backgroundColor
    }
    
    func setupView() {
        guard let tabBar = self.tabBarController?.tabBar else { return }
        guard let navHeight = navigationController?.navigationBar.frame.height else { return }
        let viewHeight = (view.bounds.height - navHeight) - 90
        collectionView.frame = CGRect(x: topView.bounds.minX, y: topView.frame.maxY + (tabBar.frame.height + 10), width: view.bounds.width, height: viewHeight - (topView.frame.height - 90))
        collectionView.backgroundColor = .clear
        guard let casters = dataSource.casters else { return }
        if casters.count > 0 {
            view.addSubview(collectionView)
        } else {
            // Add empty view
        }
    }
}

// MARK: - UIScrollViewDelegate

extension SearchResultListViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset
        guard let navHeight = self.navigationController?.navigationBar.frame.height else { return }
        let viewHeight = (self.view.bounds.height - navHeight) - 20
        let updatedTopViewFrame = CGRect(x: 0, y: 0, width: PodcastListConstants.topFrameWidth, height: PodcastListConstants.topFrameHeight / 1.2)
        let collectionFrame = CGRect(x: self.topView.bounds.minX, y: self.topView.frame.maxY, width: self.view.bounds.width, height: viewHeight - (self.topView.frame.height - 80))
        if offset.y > PodcastListConstants.minimumOffset && episodes.count > 11 {
            UIView.animate(withDuration: 0.5) {
                self.topView.removeFromSuperview()
                self.topView.alpha = 0
                self.collectionView.frame = self.view.bounds
                DispatchQueue.main.async {
                    self.collectionView.layoutIfNeeded()
                }
            }
        } else {
            UIView.animate(withDuration: 0.15) {
                guard let navHeight = self.navigationController?.navigationBar.frame.height else { return }
                self.topView.frame = updatedTopViewFrame
                self.topView.alpha = 1
                self.topView.layoutSubviews()
                self.view.addSubview(self.topView)
                self.collectionView.frame = collectionFrame
                
            }
        }
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        DispatchQueue.main.async {
            self.collectionView.reloadItems(at: self.collectionView.indexPathsForVisibleItems)
            self.collectionView.layoutIfNeeded()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        DispatchQueue.main.async {
            self.collectionView.reloadItems(at: self.collectionView.indexPathsForVisibleItems)
            self.collectionView.layoutIfNeeded()
        }
    }
}

// MARK: - UICollectionViewDelegate

extension SearchResultListViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        state = .toPlayer
        delegate?.didSelectPodcastAt(at: indexPath.row, podcast: item, with: episodes)
    }
}

// MARK: - UICollectionViewDataSource

extension SearchResultListViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return episodes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as PodcastResultCell
        DispatchQueue.main.async {
            if let playTime = self.episodes[indexPath.row].stringDuration {
                let model = PodcastResultCellViewModel(podcastTitle: self.episodes[indexPath.row].title, playtimeLabel: playTime)
                cell.configureCell(model: model)
            }
        }
        return cell
    }
}

final class SearchItemsFlowLayout: UICollectionViewFlowLayout {
    
    func setup() {
        scrollDirection = .vertical
        itemSize = CGSize(width: UIScreen.main.bounds.width / 1.01, height: UIScreen.main.bounds.height / 10)
        sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 30, right: 0)
        minimumLineSpacing = 2
    }
}
