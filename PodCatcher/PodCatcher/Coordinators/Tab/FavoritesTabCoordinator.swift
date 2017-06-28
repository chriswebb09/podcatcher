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
        if dataSource.user != nil {
            dataSource.user = nil
        }
        delegate?.transitionCoordinator(type: .app, dataSource: dataSource)
    }
    
    func didSelect(at index: Int) {
        let item = trackListDataSource.items[index]
        let resultsList = SearchResultListViewController(index: index)
        resultsList.delegate = self
        resultsList.item = item as! CasterSearchResult
        guard let feedUrlString = resultsList.item.feedUrl else { return }
        RSSFeedAPIClient.requestFeed(for: feedUrlString) { response in
            guard let items = response.0 else { return }
            resultsList.newItems = items
            DispatchQueue.main.async {
                resultsList.collectionView.reloadData()
            }
        }
        navigationController.viewControllers.append(resultsList)
    }
}

extension FavoritesTabCoordinator: PodcastListViewControllerDelegate {
    
    func didSelectPodcastAt(at index: Int, with podcast: Caster) {
        let playerView = PlayerView()
        let playerViewController = PlayerViewController(playerView: playerView, index: index, caster: podcast, user: dataSource.user)
        playerViewController.delegate = self
        navigationController.viewControllers.append(playerViewController)
    }
}

extension FavoritesTabCoordinator: PlayerViewControllerDelegate {
    func skipButton(tapped: Bool) {
        
    }

    func pauseButton(tapped: Bool) {
        
    }

    func playButton(tapped: Bool) {
        
    }
}
