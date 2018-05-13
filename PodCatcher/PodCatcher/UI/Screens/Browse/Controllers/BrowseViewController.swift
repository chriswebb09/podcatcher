import UIKit
import Reachability

final class BrowseViewController: BaseCollectionViewController, LoadingPresenting {
    
    static let headerId = "HeaderSection"
    
    weak var delegate: BrowseViewControllerDelegate?
    
    weak var coordinator: BrowseCoordinator?
   let browsePageController = BrowseTopCollectionViewController()
    var currentPlaylistId: String = ""
    var reach: Reachable?
    let browseTopView = BrowseTopView()
    
//    var topItems: [PodcastItem] = [] {
//        didSet {
//            if collectionView.visibleCells.count <= 0 {
//                DispatchQueue.main.async { [unowned self] in
//                    self.collectionView.reloadData()
//                }
//            }
//        }
//    }
    
    //    var topItems = [CasterSearchResult]() {
    //        didSet {
    //            topItems = dataSource.items
    //            if topItems.count > 0, let artUrl = topItems[0].podcastArtUrlString, let url = URL(string: artUrl) {
    //                browseTopView.podcastImageView.downloadImage(url: url)
    //                DispatchQueue.main.async {
    //                    self.browseTopView.setTitle(title: self.dataSource.items[self.browseTopView.index].podcastArtist!)
    //                    let mediaViewController = self.browsePageController.pages[0] as! MediaViewController
    //                    mediaViewController.topView.podcastImageView = self.browseTopView.podcastImageView
    //                    mediaViewController.topView.setTitle(title: self.dataSource.items[0].podcastTitle!)
    //                }
    //            }
    //
    //            if topItems.count > 1, let artUrl = topItems[1].podcastArtUrlString, let url = URL(string: artUrl) {
    //                self.browseTopView.setTitle(title: self.dataSource.items[self.browseTopView.index].podcastArtist!)
    //                let mediaViewController = self.browsePageController.pages[1] as! MediaViewController
    //                mediaViewController.topView.podcastImageView.downloadImage(url: url)
    //                mediaViewController.topView.setTitle(title: self.dataSource.items[1].podcastTitle!)
    //            }
    //        }
    //    }
    //
   // var topView = UIView()
    var tap: UITapGestureRecognizer!
    let loadingPop = LoadingPopover()
    let reachability = Reachability()!
    var network = InformationView(data: "CANNOT CONNECT TO NETWORK", icon: #imageLiteral(resourceName: "network-icon"))
    let sectionHeader = BrowseSection()
    
    var dataSource: BrowseCollectionDataSource! {
        didSet {
            viewShown = dataSource.viewShown
        }
    }
    
    var viewShown: ShowView = .empty {
        didSet {
            switch viewShown {
            case .empty:
                print("empty")
            case .collection:
                print("collection")
            }
        }
    }
    
    init(index: Int) {
        self.dataSource = BrowseCollectionDataSource()
        super.init(nibName: nil, bundle: nil)
        showLoadingView(loadingPop: loadingPop)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    var topView = UIView()
    
    var topItems: [Podcast] = [] {
        didSet {
            if collectionView.visibleCells.count <= 0 {
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
    var cellModels: [TopPodcastCellViewModel] = []
    
    let concurrentPhotoQueue = DispatchQueue(label: "com.concurrent3.Queue", attributes: .concurrent)
    
   // let browsePageController = BrowseTopCollectionViewController()
    
    var featuredItems: [Podcast] = [] {
        didSet {
            DispatchQueue.main.async {
                self.browsePageController.topItems = self.featuredItems
                self.browsePageController.collectionView.reloadData()
            }
        }
    }
    
   // var network = InformationView(data: "CANNOT CONNECT TO NETWORK", icon: #imageLiteral(resourceName: "network-icon"))
   // let loadingPop = LoadingPopover()
    var added: [String] = []
   // let sectionHeader = BrowseSection()
    
    var gameTimer: Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        edgesForExtendedLayout = []
      //.  browsePageController.delegate = self
        view.addSubview(topView)
        topView.translatesAutoresizingMaskIntoConstraints = false
        topView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        topView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: 0).isActive = true
        topView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.32).isActive = true
        topView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        embedChild(controller: browsePageController, in: topView)
//        let mediaViewController = browsePageController.pages[0] as! MediaViewController
//        mediaViewController.topView.podcastImageView = self.browseTopView.podcastImageView
//
        emptyView = InformationView(data: "No Data", icon: #imageLiteral(resourceName: "mic-icon"))
        emptyView.layoutSubviews()
        view.addSubview(network)
        view.sendSubview(toBack: network)
        network.layoutSubviews()
        loadingPop.configureLoadingOpacity(alpha: 0.2)
        
        view.backgroundColor = .clear
        topView.backgroundColor = .clear
        view.addSubview(collectionView)
        let layout = BrowseItemsFlowLayout()
        layout.setup()
        setup(view: view, newLayout: layout)
        collectionView.dataSource = dataSource
        collectionView.delegate = self
        collectionView.isPagingEnabled = true
        collectionView.isScrollEnabled = true
        collectionView.decelerationRate = UIScrollViewDecelerationRateFast
        collectionView.backgroundColor = .clear
        network.frame = view.frame
        collectionView.register(TopPodcastCell.self)
        collectionView.backgroundColor = .white
        collectionView.prefetchDataSource = dataSource
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityDidChange(_:)), name: NSNotification.Name(rawValue: "ReachabilityDidChangeNotificationName"), object: nil)
        reach?.start()
        DispatchQueue.main.async {
           // self.browseTopView.t
            self.browseTopView.podcastImageView.layer.cornerRadius = 3
            self.browseTopView.podcastImageView.layer.masksToBounds = true
            self.browseTopView.layer.setCellShadow(contentView: self.topView)
            self.browseTopView.podcastImageView.layer.setCellShadow(contentView: self.browseTopView.podcastImageView)
        }
        view.add(sectionHeader)
        sectionHeader.translatesAutoresizingMaskIntoConstraints = false
        sectionHeader.widthAnchor.constraint(equalTo: view.widthAnchor, constant: 0).isActive = true
        sectionHeader.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        sectionHeader.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: 0).isActive = true
        sectionHeader.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.06).isActive = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: 0).isActive = true
        collectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        collectionView.topAnchor.constraint(equalTo: sectionHeader.bottomAnchor, constant: -15).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8).isActive = true
        collectionView.isScrollEnabled = false
        view.layoutIfNeeded()
        sectionHeader.layoutIfNeeded()
        collectionView.layoutIfNeeded()
        collectionView.delegate = self
    }
    
    
    
    func setup(view: UIView, newLayout: BrowseItemsFlowLayout) {
        newLayout.setup()
        collectionView.collectionViewLayout = newLayout
        collectionView.layoutIfNeeded()
    }
    
    
    @objc func reachabilityDidChange(_ notification: Notification) {
        print("Reachability changed")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tap = UITapGestureRecognizer(target: self, action: #selector(selectAt))
        browseTopView.podcastImageView.addGestureRecognizer(tap)
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged), name: Notification.Name.reachabilityChanged, object: reachability)
        do {
            try reachability.startNotifier()
        } catch {
            print("could not start reachability notifier")
        }
        UIView.animate(withDuration: 0.15) {
            self.view.alpha = 1
            
        }
        
        DispatchQueue.main.async { [weak self] in
            
            if let strongSelf = self {
                strongSelf.collectionView.reloadData()
            }
        }
    }
}

extension BrowseViewController: UICollectionViewDelegate {
    
    @objc func selectAt() {
        //coordinator?.didSelect(at: 0, with: dataSource.items[0], with: browseTopView.podcastImageView)
        topView.removeGestureRecognizer(tap)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.isUserInteractionEnabled = false
        let cell = collectionView.cellForItem(at: indexPath) as! TopPodcastCell
        delegate?.selectedItem(at: indexPath.row, podcast: self.dataSource.items[indexPath.row], imageView: cell.albumArtView)
        //coordinator?.didSelect(at: indexPath.row, with: self.dataSource.items[indexPath.row], with: cell.albumArtView)
    }
}

extension BrowseViewController: UIScrollViewDelegate {
    
    @objc func reachabilityChanged(note: Notification) {
        if Reachable.isInternetAvailable() {
            DispatchQueue.main.async {
                self.view.sendSubview(toBack: self.network)
            }
        } else {
            DispatchQueue.main.async {
                self.view.bringSubview(toFront: self.network)
            }
        }
    }
}

struct BrowseListTopViewConstants {
     static let podcastImageViewCenterYOffset: CGFloat = 0
    static let imageCenterYOffset: CGFloat = UIScreen.main.bounds.height * -0.01
    static let preferencesViewHeightMultiplier: CGFloat = 0.12
    static let tagsViewHeightMultiplier: CGFloat = 0.13
    static let imageHeightMultiplier: CGFloat = 0.74
    static let imageWidthMultiplier: CGFloat = 0.9
    static let podcastImageViewHeightMultiplier: CGFloat = 0.87
     static let podcastImageViewWidthMultiplier: CGFloat = 0.70
    static let titleLabelHeightMultiplier: CGFloat = 0.3
    static let titleLabelTopOffset: CGFloat = UIScreen.main.bounds.height * 0.0008
}
//    static let preferencesViewHeightMultiplier: CGFloat = 0.1
//    static let tagsViewHeightMultiplier: CGFloat = 0.13
//    static let imageHeightMultiplier: CGFloat = 0.87
//    static let imageWidthMultiplier: CGFloat = 0.76
//    static let titleLabelHeightMultiplier: CGFloat = 0.3
//    static let titleLabelTopOffset: CGFloat = UIScreen.main.bounds.height * 0.0008
//}

public enum Pattern {
    case horizontalCenter
    case horizontalLeft
    case horizontalRight
}



import UIKit

class BrowseTopCollectionViewController: UIViewController {
    var maxScale: CGFloat = 1
    private var startingScrollingOffset = CGPoint.zero
    var minScale: CGFloat = 0.6
    
    var scaledPattern: Pattern = .horizontalLeft
    var maxAlpha: CGFloat = 1.3
    var minAlpha: CGFloat = 0.4
    
    var collectionView: UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: CarouselFlowLayout())
    
    weak var delegate: BrowseTopCollectionViewControllerDelegate?
    
    var topItems: [Podcast] = []
    
    var onceOnly = false
    var pageControl: UIPageControl! = UIPageControl(frame: CGRect.zero)
    
    let cellId = "Cell"
    
    var focusedItem = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addCollectionView()
        collectionView.register(BrowseTopViewCell.self, forCellWithReuseIdentifier: BrowseTopViewCell.reuseIdentifier)
    }
    
    func addCollectionView() {
        let layout = CarouselFlowLayout()
        let frame = CGRect(x: view.frame.minX, y: view.frame.minY, width: view.frame.width, height: view.frame.height - 10)
        collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = Style.Color.Highlight.highlight
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: view.bounds.width / 1.8, height: view.frame.height / 4)
        layout.minimumInteritemSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isPagingEnabled = false
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0.0).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0.0).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0.0).isActive = true
        collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0.0).isActive = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        var insets = collectionView.contentInset
        let value = (view.frame.size.width - (collectionView.collectionViewLayout as! UICollectionViewFlowLayout).itemSize.width) * 0.5
        insets.left = value
        insets.right = value
        collectionView.contentInset = insets
        collectionView.decelerationRate = UIScrollViewDecelerationRateNormal
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    internal func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    }
}

extension BrowseTopCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if topItems.count > 3 {
            return BrowseCollectionDataSourceConstants.cellCount
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BrowseTopViewCell.reuseIdentifier, for: indexPath as IndexPath) as! BrowseTopViewCell
        let index = indexPath.row
        if topItems.count > index - 1 {
            let item = topItems[index]
            if let url = URL(string: item.podcastArtUrlString) {
                DispatchQueue.main.async {
                    cell.podcast = item
                    cell.podcastImageView.downloadImage(url: url)
                }
            }
        }
        return cell
    }
    
    func scrollTo() {
        if !onceOnly {
            let indexToScrollTo = IndexPath(item: self.topItems.count / 4, section: 0)
            DispatchQueue.main.async {
                if indexToScrollTo.row > self.topItems.count {
                    self.collectionView.reloadData()
                    return
                }
                self.collectionView.scrollToItem(at: indexToScrollTo, at: .centeredHorizontally, animated: true)
                let visibleCells = self.collectionView.visibleCells
                self.scaleCellsForHorizontalScroll(visibleCells: visibleCells)
            }
            self.onceOnly = true
        } else {
            return
        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let cellSize = CGSize(width: view.bounds.width / 2, height: view.frame.height / 4)
        targetContentOffset.pointee = scrollView.contentOffset
        var factor: CGFloat = 0.5
        if velocity.x < 0 {
            factor = -factor
        }
        let itemNumber = Int(scrollView.contentOffset.x / cellSize.width + factor)
        if itemNumber >= topItems.count - 2 || itemNumber < 0 {
            return
        } else {
            let indexPath = IndexPath(row: Int(scrollView.contentOffset.x / cellSize.width + factor), section: 0)
            let index = indexPath.row
            
            if topItems.count <= index ||  0 > index  {
                return
            } else {
                collectionView.scrollToItem(at: indexPath, at:  .left, animated: true)
            }
        }
        delegate?.topItems(loaded: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let collection = scrollView as! UICollectionView
        let visibleCells = collection.visibleCells
        scaleCellsForHorizontalScroll(visibleCells: visibleCells)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! BrowseTopViewCell
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 5, options: [],
                       animations: {
                        cell.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        }) { finished in
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 5, options: .curveEaseInOut,
                           animations: {
                            cell.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            }, completion: { finished in
                self.delegate?.goToEpisodeList(podcast: cell.podcast, at: indexPath.row, with: cell.podcastImageView!)
            })
        }
    }
    
    private func scaleCells(distanceFromMainPosition: CGFloat, maximumScalingArea: CGFloat, scalingArea: CGFloat) -> [CGFloat] {
        var preferredScale: CGFloat = 0.0
        var preferredAlpha: CGFloat = 0.0
        let maxScale = self.maxScale
        let minScale = self.minScale
        let maxAlpha = self.maxAlpha
        let minAlpha = self.minAlpha
        if distanceFromMainPosition < maximumScalingArea {
            preferredScale = maxScale
            preferredAlpha = maxAlpha
        } else if distanceFromMainPosition < (maximumScalingArea + scalingArea) {
            let multiplier = abs((distanceFromMainPosition - maximumScalingArea) / scalingArea)
            preferredScale = maxScale - multiplier * (maxScale - minScale)
            preferredAlpha = maxAlpha - multiplier * (maxAlpha - minAlpha)
        } else {
            preferredScale = minScale
            preferredAlpha = minAlpha
        }
        return [ preferredScale, preferredAlpha ]
    }
    
    private func scaleCellsForHorizontalScroll(visibleCells: [UICollectionViewCell]) {
        let scalingAreaWidth = collectionView.bounds.width / 2
        let maximumScalingAreaWidth = (collectionView.bounds.width / 2 - scalingAreaWidth) / 2
        for cell in visibleCells  {
            var distanceFromMainPosition: CGFloat = 0
            switch scaledPattern {
            case .horizontalCenter:
                distanceFromMainPosition = horizontalCenter(cell: cell)
                break
            case .horizontalLeft:
                distanceFromMainPosition = abs(cell.frame.midX - collectionView.contentOffset.x - (cell.bounds.width / 2))
                break
            case .horizontalRight:
                distanceFromMainPosition = abs(collectionView.bounds.width / 2 - (cell.frame.midX - collectionView.contentOffset.x) + (cell.bounds.width / 2))
                break
            }
            let preferredAry = scaleCells(distanceFromMainPosition: distanceFromMainPosition, maximumScalingArea: maximumScalingAreaWidth, scalingArea: scalingAreaWidth)
            let preferredScale = preferredAry[0]
            let preferredAlpha = preferredAry[1]
            cell.transform = CGAffineTransform(scaleX: preferredScale, y: preferredScale)
            cell.alpha = preferredAlpha
        }
    }
    
    private func horizontalCenter(cell: UICollectionViewCell)-> CGFloat {
        return abs(collectionView.bounds.width / 2 - (cell.frame.midX - collectionView.contentOffset.x))
    }
}

import UIKit

class CarouselFlowLayout: UICollectionViewFlowLayout {
    
    var mostRecentOffset : CGPoint = CGPoint()
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        
        if velocity.x == 0 {
            return mostRecentOffset
        }
        
        if let cv = self.collectionView {
            let cvBounds = cv.bounds
            let halfWidth = cvBounds.size.width * 0.5;
            if let attributesForVisibleCells = self.layoutAttributesForElements(in: cvBounds) {
                var candidateAttributes : UICollectionViewLayoutAttributes?
                for attributes in attributesForVisibleCells {
                    // == Skip comparison with non-cell items (headers and footers) == //
                    if attributes.representedElementCategory != UICollectionElementCategory.cell {
                        continue
                    }
                    if (attributes.center.x == 0) || (attributes.center.x > (cv.contentOffset.x + halfWidth) && velocity.x < 0) {
                        continue
                    }
                    candidateAttributes = attributes
                }
                if proposedContentOffset.x == -(cv.contentInset.left) {
                    return proposedContentOffset
                }
                guard let _ = candidateAttributes else { return mostRecentOffset }
                mostRecentOffset = CGPoint(x: floor(candidateAttributes!.center.x - halfWidth), y: proposedContentOffset.y)
                return mostRecentOffset
            }
        }
        mostRecentOffset = super.targetContentOffset(forProposedContentOffset: proposedContentOffset)
        return mostRecentOffset
    }
}

import UIKit

final class BrowseTopViewCell: UICollectionViewCell {
    
    var index: Int = 0
    
    // MARK: - UI Properties
    
    var podcast: Podcast!
    
    var titleLabel: UILabel = {
        let title = UILabel()
        title.textColor = .white
        title.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        title.textAlignment = .center
        title.numberOfLines = 0
        return title
    }()
    
    var podcastImageView: UIImageView! = {
        var podcastImageView = UIImageView()
        podcastImageView.layer.setCellShadow(contentView: podcastImageView)
        podcastImageView.layer.cornerRadius = 8
        return podcastImageView
    }()
    
    var background = UIView()
    
    var podcastTitleLabel: UILabel! = {
        var podcastTitle = UILabel()
        podcastTitle.textAlignment = .center
        return podcastTitle
    }()
    
    var overlayView: UIView = {
        let overlay = UIView()
        overlay.backgroundColor = .black
        overlay.alpha = 0.3
        return overlay
    }()
    
    private struct InternalConstants {
        static let alphaSmallestValue: CGFloat = 0.85
        static let scaleDivisor: CGFloat = 10.0
    }
    
    var dataView: UIView = {
        var dataView = UIView()
        dataView.backgroundColor = .clear
        return dataView
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        sendSubview(toBack: background)
        setupConstraints()
        layer.setCellShadow(contentView: self)
        layoutIfNeeded()
        clipsToBounds = false
        layer.cornerRadius = 9
        podcastImageView.layer.cornerRadius = 6
        background.backgroundColor = UIColor(red:0.19, green:0.23, blue:0.26, alpha:1.0)
    }
    
    func setBackground() {
        let background = UIImageView()
        background.image = podcastImageView.image
        background.frame = CGRect(x: frame.minX, y: frame.minY - 2, width: frame.width, height: frame.height)
        add(background)
        background.addBlurEffect()
        bringSubview(toFront: podcastImageView)
        background.alpha = 0.6
    }
    
    func setupConstraints() {
        setup(podcastImageView: podcastImageView)
        setup(titleLabel: titleLabel)
    }
    
    func setup(podcastImageView: UIImageView) {
        addSubview(podcastImageView)
        podcastImageView.translatesAutoresizingMaskIntoConstraints = false
        podcastImageView.centerXAnchor.constraint(equalTo: centerXAnchor)
        if #available(iOS 11, *) {
            NSLayoutConstraint.activate([
                podcastImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
                podcastImageView.heightAnchor.constraint(equalTo: heightAnchor),
                podcastImageView.widthAnchor.constraint(equalTo: widthAnchor)
                ])
        } else {
            NSLayoutConstraint.activate([
                podcastImageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: BrowseListTopViewConstants.imageCenterYOffset),
                podcastImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: BrowseListTopViewConstants.imageHeightMultiplier),
                podcastImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: BrowseListTopViewConstants.imageWidthMultiplier)
                ])
            podcastImageView.layoutIfNeeded()
            layoutIfNeeded()
        }
    }
    
    func setup(dataView: UIView) {
        add(dataView)
        dataView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dataView.topAnchor.constraint(equalTo: topAnchor),
            dataView.widthAnchor.constraint(equalTo: widthAnchor),
            dataView.heightAnchor.constraint(equalTo: heightAnchor)
            ])
    }
    
    func setup(overlayView: UIView) {
        dataView.add(overlayView)
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            overlayView.topAnchor.constraint(equalTo: dataView.topAnchor),
            overlayView.widthAnchor.constraint(equalTo: dataView.widthAnchor),
            overlayView.heightAnchor.constraint(equalTo: dataView.heightAnchor)
            ])
    }
    
    func setup(titleLabel: UILabel) {
        dataView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 480, 960:
                NSLayoutConstraint.activate([
                    titleLabel.heightAnchor.constraint(equalTo: dataView.heightAnchor, multiplier: 0.3)
                    ])
            case 1136, 1334, 2208:
                NSLayoutConstraint.activate([
                    titleLabel.heightAnchor.constraint(equalTo: dataView.heightAnchor, multiplier: 0.4)
                    ])
            default:
                break
            }
            NSLayoutConstraint.activate([
                titleLabel.centerXAnchor.constraint(equalTo: dataView.centerXAnchor),
                titleLabel.widthAnchor.constraint(equalTo: dataView.widthAnchor),
                titleLabel.centerYAnchor.constraint(equalTo: dataView.centerYAnchor)
                ])
        }
    }
    
    func setTitle(title: String) {
        titleLabel.text = title
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}

struct BrowseCollectionDataSourceConstants {
    static let cellCount:Int = 4
}


protocol BrowseCollectionDataSourceDelegate: class {
    func itemsSet(items: [Podcast])
}


protocol BrowseTopCollectionViewControllerDelegate: class {
    func topItems(loaded: Bool)
    func goToEpisodeList(podcast: Podcast, at index: Int, with imageView: UIImageView)
}

