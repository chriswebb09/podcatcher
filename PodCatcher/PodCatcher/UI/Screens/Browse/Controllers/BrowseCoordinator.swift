import UIKit
import ReachabilitySwift

protocol ControllerCoordinator: class {
    func viewDidLoad(_ viewController: UIViewController)
}

protocol BrowseCoordinator: ControllerCoordinator { }

extension BrowseCoordinator {
    
    func viewDidLoad(_ viewController: UIViewController) {

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

