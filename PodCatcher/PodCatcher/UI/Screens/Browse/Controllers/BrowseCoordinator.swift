import UIKit
import ReachabilitySwift

protocol ControllerCoordinator: class {
    func viewDidLoad(_ viewController: UIViewController)
}

protocol BrowseCoordinator: ControllerCoordinator { }
extension BrowseCoordinator {
    func viewDidLoad(_ viewController: UIViewController) {
        let browseVC = viewController as! BrowseViewController
        browseVC.emptyView = InformationView(data: "No Data", icon: #imageLiteral(resourceName: "mic-icon"))
        browseVC.emptyView.layoutSubviews()
        browseVC.view.addSubview(browseVC.network)
        browseVC.view.sendSubview(toBack: browseVC.network)
        browseVC.network.layoutSubviews()
        let topFrameHeight = UIScreen.main.bounds.height / 2
        let topFrameWidth = UIScreen.main.bounds.width
        let topFrame = CGRect(x: 0, y: 0, width: topFrameWidth, height: topFrameHeight + 40)
        browseVC.topView.frame = topFrame
        browseVC.loadingPop.configureLoadingOpacity(alpha: 0.2)
        browseVC.view.addSubview(browseVC.topView)
        browseVC.view.backgroundColor = .clear
        browseVC.topView.backgroundColor = .clear
        browseVC.view.addSubview(browseVC.collectionView)
        collectionViewConfiguration(view: browseVC.view, collectionView: browseVC.collectionView)
        browseVC.collectionView.delegate = browseVC
        browseVC.collectionView.dataSource = browseVC.dataSource
        browseVC.network.frame = viewController.view.frame
        browseVC.collectionView.register(TopPodcastCell.self)
        browseVC.collectionView.backgroundColor = .darkGray
        browseVC.collectionView.prefetchDataSource = browseVC.dataSource
        //
        DispatchQueue.main.async {
            browseVC.collectionView.reloadData()
        }
        NotificationCenter.default.addObserver(self, selector: #selector(BrowseViewController.reachabilityDidChange(_:)), name: NSNotification.Name(rawValue: "ReachabilityDidChangeNotificationName"), object: nil)
        browseVC.reach?.start()
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

