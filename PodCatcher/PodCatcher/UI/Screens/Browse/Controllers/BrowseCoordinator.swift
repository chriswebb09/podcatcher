import UIKit
import ReachabilitySwift

protocol BrowseCoordinator: ControllerCoordinator {
    func didSelect(at index: Int, with cast: PodcastSearchResult, with imageView: UIImageView)
}

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
        let topFrame = CGRect(x: 0, y: 0, width: topFrameWidth, height: topFrameHeight + 100)
        browseVC.topView.frame = topFrame
        browseVC.loadingPop.configureLoadingOpacity(alpha: 0.2)
        browseVC.view.addSubview(browseVC.topView)
        browseVC.view.backgroundColor = .clear
        browseVC.topView.backgroundColor = .clear
        browseVC.view.addSubview(browseVC.collectionView)
        
        browseVC.setup(view: browseVC.view, newLayout: BrowseItemsFlowLayout())
        browseVC.collectionView.dataSource = browseVC.dataSource
        browseVC.collectionView.delegate = browseVC
        browseVC.collectionView.isPagingEnabled = true
        browseVC.collectionView.isScrollEnabled = true
        browseVC.collectionView.decelerationRate = UIScrollViewDecelerationRateFast
        browseVC.collectionView.backgroundColor = .clear
        browseVC.network.frame = browseVC.view.frame
        browseVC.collectionView.register(TopPodcastCell.self)
        browseVC.collectionView.backgroundColor = .darkGray
        browseVC.collectionView.prefetchDataSource = browseVC.dataSource
    }
}
