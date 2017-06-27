import UIKit

class FavoritesTabCoordinator: NavigationCoordinator {
    
    weak var delegate: CoordinatorDelegate?
    var type: CoordinatorType = .tabbar
    var dataSource: BaseMediaControllerDataSource!
    var trackListDataSource: ListControllerDataSource!
    
    var childViewControllers: [UIViewController] = []
    var navigationController: UINavigationController
    
    required init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.childViewControllers = navigationController.viewControllers
    }
    
    convenience init(navigationController: UINavigationController, controller: UIViewController) {
        self.init(navigationController: navigationController)
        navigationController.viewControllers = [controller]
    }
    
    func start() {
        let favoritesController = navigationController.viewControllers[0] as! SearchViewController
        trackListDataSource = favoritesController.dataSource
        favoritesController.delegate = self
    }
}

extension FavoritesTabCoordinator: SearchViewControllerDelegate {
    func logout(tapped: Bool) {
        
    }
    
    func didSelect(at index: Int) {
        var item = trackListDataSource.items[index]
        let resultsList = SearchResultListViewController(index: index)
        resultsList.item = item as! CasterSearchResult
        navigationController.viewControllers.append(resultsList)
    }
}
