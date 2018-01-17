import UIKit

final class SearchResultListViewController: BaseCollectionViewController {
    
    weak var delegate: PodcastListViewControllerDelegate?
    
    private var item: CasterSearchResult!
    private var state: PodcasterControlState = .toCollection
    
    var navPop = false
    
    private var confirmationIndicator = ConfirmationIndicatorView()
    private let entryPop = EntryPopover()
    
    var topView = ListTopView()
    var dataSource: SearchResultDatasource! = SearchResultDatasource()
    
    var topViewHeightConstraint: NSLayoutConstraint!
    var topViewWidthConstraint: NSLayoutConstraint!
    var topViewYConstraint: NSLayoutConstraint!
    var topViewXConstraint: NSLayoutConstraint!
    var topViewTopConstraint: NSLayoutConstraint!
    var topViewBottomConstraint: NSLayoutConstraint!
    
    private let subscription = UserDefaults.loadSubscriptions()
    
    private(set) var viewShown: ShowView {
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
        collectionView.register(PodcastResultCell.self)
        //  dataSource =
        view.backgroundColor = .white
        initialize()
        setupNavbar()
        collectionView.layoutIfNeeded()
    }
    
    private func initialize() {
        emptyView = InformationView(data: "No Data.", icon: #imageLiteral(resourceName: "mic-icon"))
        setup(dataSource: dataSource, delegate: self)
        setupView()
        collectionView.register(PodcastResultCell.self)
    }
    
    func setDataItem(dataItem: CasterSearchResult) {
        item = dataItem
        dataSource.setItem(item: item)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        setupNavbar()
        navigationItem.title = item.podcastTitle
        setupNavbar()
        setupButton()
        setupTopViewImage()
        showViews()
        setupLayout()
        topView.layoutIfNeeded()
    }
    
    private func setupLayout() {
        let newLayout = SearchItemsFlowLayout()
        newLayout.setup()
        collectionView.collectionViewLayout.invalidateLayout()
        collectionView.collectionViewLayout = newLayout
    }
    
    private func setupButton() {
        DispatchQueue.main.async {
            if let item = self.item, let feedUrl = item.feedUrl, !self.subscription.contains(feedUrl) {
                let button = UIButton.setupSubscribeButton()
                button.addTarget(self, action: #selector(self.subscribeToFeed), for: .touchUpInside)
                self.topView.preferencesView.moreMenuButton = button
                self.topView.layoutSubviews()
            }
        }
    }
    
    private func setupNavbar() {
        DispatchQueue.main.async {
            let backImage = #imageLiteral(resourceName: "back").withRenderingMode(.alwaysTemplate)
            self.navigationController?.navigationBar.backIndicatorImage = backImage
            self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = backImage
            self.navigationController?.navigationBar.backItem?.title = ""
        }
    }
    
    private func setupTopViewImage() {
        DispatchQueue.main.async {
            self.topView.configureTopImage()
        }
    }
    
    private func saveFeed() {
        guard let image = topView.podcastImageView.image else { return }
        delegate?.saveFeed(item: item, podcastImage: image , episodesCount: item.episodes.count)
        topView.preferencesView.moreMenuButton.isHidden = true
    }
    
    private func showViews() {
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
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(false)
        navPop = false 
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
    
    private func setupView() {
        setupTopView()
        setupViewFraming()
        collectionView.backgroundColor = .clear
        view.addSubview(collectionView)
        setupBackgroundView()
    }
    
    private func setupBackgroundView() {
        background.frame = view.frame
        
        view.addSubview(background)
        view.sendSubview(toBack: background)
    }
    
    func setupViewFraming() {
        
    }
    
    func setupTopView() {
        view.addSubview(self.topView)
        topView.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 11, *) {
            topViewTopConstraint = topView.topAnchor.constraintEqualToSystemSpacingBelow(topLayoutGuide.bottomAnchor, multiplier: 0.2)
            topViewTopConstraint.isActive = true
        } else {
            topViewTopConstraint = topView.topAnchor.constraint(equalTo: view.topAnchor)
            topViewTopConstraint.isActive = true 
        }
        topViewHeightConstraint = topView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.45)
        topViewHeightConstraint.isActive = true
        
        topViewWidthConstraint = topView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1)
        topViewWidthConstraint.isActive = true
        
        topView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.collectionView.topAnchor.constraint(equalTo: topView.bottomAnchor).isActive = true
        self.collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        self.collectionView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        if let item = item, let urlString = item.podcastArtUrlString, let url = URL(string: urlString) {
            topView.podcastImageView.downloadImage(url: url)
        }
        topView.layoutIfNeeded()
        view.layoutIfNeeded()
        topView.delegate = self
    }
}

extension SearchResultListViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.collectionView.updateCollectionViewLayout()
    }
    
    private func updateScrollUIFull() {
        self.topViewHeightConstraint.isActive = false
        self.topViewWidthConstraint.isActive = false
        UIView.animate(withDuration: 0.1) {
            self.topView.alpha = 0
        }
        UIView.animate(withDuration: 0.5) {
            self.topView.removeFromSuperview()
            self.collectionView.frame = self.view.bounds
            self.collectionView.layoutIfNeeded()
            self.view.layoutIfNeeded()
            self.topView.layoutIfNeeded()
        }
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        collectionView.updateCollectionViewLayout()
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        collectionView.updateCollectionViewLayout()
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        DispatchQueue.main.async {
            self.collectionView.reloadSections(IndexSet(integersIn: 0...0))
        }
        collectionView.updateCollectionViewLayout()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        DispatchQueue.main.async {
            self.collectionView.reloadSections(IndexSet(integersIn: 0...0))
        }
        collectionView.updateCollectionViewLayout()
    }
}

extension SearchResultListViewController: TopViewDelegate {
    func popBottomMenu(popped: Bool) {
        print("bottom")
    }
    
    func entryPop(popped: Bool) {
        print("popped")
    }
    
    func infoButton(tapped: Bool) {
        print(item.tags)
    }
}

// MARK: - UICollectionViewDelegate

extension SearchResultListViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        state = .toPlayer
        delegate?.didSelectPodcastAt(at: indexPath.row, podcast: item, with: item.episodes)
    }
}
