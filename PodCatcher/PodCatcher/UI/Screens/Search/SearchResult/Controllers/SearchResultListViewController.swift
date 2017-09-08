import UIKit

final class SearchResultListViewController: BaseCollectionViewController {
    
    var dataSource: BaseMediaControllerDataSource!
    
    weak var delegate: PodcastListViewControllerDelegate?
    
    var item: CasterSearchResult!
    var state: PodcasterControlState = .toCollection
    var confirmationIndicator = ConfirmationIndicatorView()
    let entryPop = EntryPopover()
    var topView = ListTopView()
    
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
        initialize()
    }
    
    func initialize() {
        emptyView = InformationView(data: "No Data.", icon: #imageLiteral(resourceName: "mic-icon"))
        setup(dataSource: self, delegate: self)
        setupView()
        
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
        setupNavbar()
        setupButton()
        setupTopViewImage()
        showViews()
        setupLayout()
    }
    
    func setupNavbar() {
        let backImage = #imageLiteral(resourceName: "back").withRenderingMode(.alwaysTemplate)
        navigationController?.navigationBar.backIndicatorImage = backImage
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = backImage
    }
    
    func setupLayout() {
        let newLayout = SearchItemsFlowLayout()
        newLayout.setup()
        self.collectionView.collectionViewLayout.invalidateLayout()
        self.collectionView.collectionViewLayout = newLayout
    }
    
    func setupButton() {
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: self, action: nil)
            strongSelf.navigationItem.backBarButtonItem = backButton
            if let item = strongSelf.item, let title = item.podcastTitle {
                strongSelf.navigationItem.title = title
            }
        }
        
        if let item = item, let feedUrl = item.feedUrl, !subscription.contains(feedUrl), let title = item.podcastTitle {
            let button = UIButton.setupSubscribeButton()
            button.addTarget(self, action: #selector(subscribeToFeed), for: .touchUpInside)
            topView.preferencesView.moreMenuButton = button
        }
    }
    
    func setupTopViewImage() {
        DispatchQueue.main.async {
            self.topView.configureTopImage()
        }
    }
    
    func saveFeed() {
        guard let image = topView.podcastImageView.image else { return }
        delegate?.saveFeed(item: item, podcastImage: image , episodesCount: item.episodes.count)
        topView.preferencesView.moreMenuButton.isHidden = true
    }
    
    func showViews() {
        collectionView.alpha = 1
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.navigationBar.alpha = 1
    }
    
    @objc func subscribeToFeed() {
        saveFeed()
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            UIView.animate(withDuration: 0.2) {
                strongSelf.confirmationIndicator.showActivityIndicator(viewController: strongSelf)
            }
            UIView.animate(withDuration: 1, animations: {
                strongSelf.confirmationIndicator.loadingView.alpha = 0
            }, completion: { finished in
                strongSelf.confirmationIndicator.hideActivityIndicator(viewController: strongSelf)
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
    
    func setup(dataSource: UICollectionViewDataSource, delegate: UICollectionViewDelegate) {
        collectionView.dataSource = dataSource
        collectionView.delegate = delegate
        collectionView.backgroundColor = PodcastListConstants.backgroundColor
    }
    
    func setupView() {
        setupTopView()
        guard let tabBar = tabBarController?.tabBar else { return }
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
        setupBackgroundView()
    }
    
    func setupTopView() {
        topView.frame = PodcastListConstants.topFrame
        if let item = item, let urlString = item.podcastArtUrlString, let url = URL(string: urlString) {
            topView.podcastImageView.downloadImage(url: url)
        }
        topView.layoutSubviews()
        view.addSubview(topView)
        view.bringSubview(toFront: topView)
    }
    
    func setupBackgroundView() {
        background.frame = view.frame
        view.addSubview(background)
        view.sendSubview(toBack: background)
    }
}

// MARK: - UIScrollViewDelegate

extension SearchResultListViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset
        if offset.y > PodcastListConstants.minimumOffset && item.episodes.count > 11 {
            updateScrollUIFull()
        } else {
            updateScrollingUITop()
        }
    }
    
    
    func updateScrollUIFull() {
        UIView.animate(withDuration: 0.5) {
            self.topView.removeFromSuperview()
            self.topView.alpha = 0
            self.collectionView.frame = self.view.bounds
            DispatchQueue.main.async {
                self.collectionView.layoutIfNeeded()
            }
        }
    }
    
    func updateScrollingUITop() {
        guard let navHeight = navigationController?.navigationBar.frame.height else { return }
        let viewHeight = (view.bounds.height - navHeight) - 20
        let updatedTopViewFrame = CGRect(x: 0, y: 0, width: PodcastListConstants.topFrameWidth, height: PodcastListConstants.topFrameHeight / 1.2)
        let collectionFrame = CGRect(x: topView.bounds.minX, y: topView.frame.maxY, width: view.bounds.width, height: viewHeight - (topView.frame.height - 80))
        UIView.animate(withDuration: 0.15) {
            self.topView.frame = updatedTopViewFrame
            self.topView.alpha = 1
            self.topView.layoutSubviews()
            self.view.addSubview(self.topView)
            self.collectionView.frame = collectionFrame
        }
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        collectionView.updateCollectionViewLayout()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        collectionView.updateCollectionViewLayout()
    }
}

// MARK: - UICollectionViewDelegate

extension SearchResultListViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        state = .toPlayer
        delegate?.didSelectPodcastAt(at: indexPath.row, podcast: item, with: item.episodes)
    }
}

// MARK: - UICollectionViewDataSource

extension SearchResultListViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return item.episodes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as PodcastResultCell
        DispatchQueue.main.async {
            if let playTime = self.item.episodes[indexPath.row].stringDuration {
                let model = PodcastResultCellViewModel(podcastTitle: self.item.episodes[indexPath.row].title, playtimeLabel: playTime)
                cell.configureCell(model: model)
            }
        }
        return cell
    }
}
