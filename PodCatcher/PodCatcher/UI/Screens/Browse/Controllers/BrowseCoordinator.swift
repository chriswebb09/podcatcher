import UIKit
import ReachabilitySwift

protocol ControllerCoordinator: class {
    func viewDidLoad(_ viewController: UIViewController)
}

protocol BrowseCoordinator: class {
    func viewDidLoad(_ viewController: BrowseViewController)
}

extension BrowseCoordinator {
    func viewDidLoad(_ viewController: BrowseViewController) {
        viewController.emptyView = InformationView(data: "No Data", icon: #imageLiteral(resourceName: "mic-icon"))
        viewController.emptyView.layoutSubviews()
        viewController.view.addSubview(viewController.network)
        viewController.view.sendSubview(toBack: viewController.network)
        viewController.network.layoutSubviews()
        let topFrameHeight = UIScreen.main.bounds.height / 2
        let topFrameWidth = UIScreen.main.bounds.width
        let topFrame = CGRect(x: 0, y: 0, width: topFrameWidth, height: topFrameHeight + 40)
        viewController.topView.frame = topFrame
        viewController.loadingPop.configureLoadingOpacity(alpha: 0.2)
        viewController.view.addSubview(viewController.topView)
        viewController.view.backgroundColor = .clear
        viewController.topView.backgroundColor = .clear
        viewController.view.addSubview(viewController.collectionView)
        collectionViewConfiguration(view: viewController.view, collectionView: viewController.collectionView)
        viewController.collectionView.delegate = viewController
        viewController.collectionView.dataSource = viewController.dataSource
        viewController.network.frame = viewController.view.frame
        viewController.collectionView.register(TopPodcastCell.self)
        viewController.collectionView.backgroundColor = .darkGray
        viewController.collectionView.prefetchDataSource = viewController.dataSource
        viewController.tap = UITapGestureRecognizer(target: self, action: #selector(BrowseViewController.selectAt))
        viewController.collectionView.register(SectionHeaderView.self, forSupplementaryViewOfKind: "UICollectionReusableView", withReuseIdentifier: "SectionHeader")
        DispatchQueue.main.async {
            viewController.collectionView.reloadData()
        }
        NotificationCenter.default.addObserver(self, selector: #selector(BrowseViewController.reachabilityDidChange(_:)), name: NSNotification.Name(rawValue: "ReachabilityDidChangeNotificationName"), object: nil)
        viewController.reach?.start()
    }
    
    func collectionViewConfiguration(view: UIView, collectionView: UICollectionView) {
        setup(view: view, collectionView: collectionView, newLayout: BrowseItemsFlowLayout())
        
        collectionView.isPagingEnabled = true
        collectionView.isScrollEnabled = true
        collectionView.decelerationRate = UIScrollViewDecelerationRateFast
        collectionView.backgroundColor = .clear
    }
    
    func setup(view: UIView, collectionView: UICollectionView, newLayout: BrowseItemsFlowLayout) {
        newLayout.setup()
        collectionView.collectionViewLayout = newLayout
        collectionView.frame = CGRect(x: 0, y: view.bounds.midY + 40, width: UIScreen.main.bounds.width, height: (UIScreen.main.bounds.height / 2) - 40)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}

