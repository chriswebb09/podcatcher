import UIKit

protocol HomeCoordinator: ControllerCoordinator { }

extension HomeCoordinator {
    func viewDidLoad(_ viewController: UIViewController) {
        let homeVC = viewController as! HomeViewController
        let newLayout = HomeItemsFlowLayout()
        newLayout.setup()
        homeVC.emptyView = InformationView(data: "Subscribe to your favorite podcasts!", icon:  #imageLiteral(resourceName: "mic-icon"))
        homeVC.emptyView.setLabel(text: "Subscribe to your favorite podcasts!")
        homeVC.emptyView.setIcon(icon: #imageLiteral(resourceName: "mic-icon"))
        homeVC.emptyView.frame = homeVC.view.frame
        homeVC.emptyView.layoutSubviews()
        homeVC.collectionView.collectionViewLayout = newLayout
        homeVC.collectionView.frame = UIScreen.main.bounds
        homeVC.collectionView.register(SubscribedPodcastCell.self)
        homeVC.collectionView.setupBackground(frame: homeVC.view.bounds)
        homeVC.navigationItem.setRightBarButton(homeVC.rightButtonItem, animated: false)
        homeVC.setupDataSource()
        homeVC.collectionView.delegate = homeVC
        homeVC.view.bringSubview(toFront: homeVC.collectionView)
        homeVC.collectionView.backgroundColor = .lightGray
        homeVC.background.backgroundColor = .lightGray
    }
}
