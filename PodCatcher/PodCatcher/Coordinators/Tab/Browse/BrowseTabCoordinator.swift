import UIKit

final class BrowseTabCoordinator: NavigationCoordinator {
    
    weak var delegate: CoordinatorDelegate?
    var type: CoordinatorType = .tabbar
    var dataSource: BaseMediaControllerDataSource!
    var store = SearchResultsDataStore()
    var fetcher = SearchResultsFetcher()
    
    let mainStore = MainStore()
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
        let homeViewController = navigationController.viewControllers[0] as! BrowseViewController
        homeViewController.delegate = self
    }
    
    func setup() {
        let homeViewController = navigationController.viewControllers[0] as! BrowseViewController
        let mainStore = MainStore()
        DispatchQueue.global(qos: .background).async { [weak self] in
            if let strongSelf = self {
                strongSelf.store.pullFeedTopPodcasts { data, error in
                    UserDefaults.standard.set(Date(), forKey: "topItems")
                    guard let data = data else { return }
                    var results = [CasterSearchResult]()
                    for item in data {
                        strongSelf.fetcher.setLookup(term: item.id)
                        strongSelf.fetcher.searchForTracksFromLookup { result in
                            guard let resultItem = result.0 else { return }
                            resultItem.forEach { resultingData in
                                guard let resultingData = resultingData else { return }
                                if let caster = CasterSearchResult(json: resultingData) {
                                    results.append(caster)
                                    DispatchQueue.main.async {
                                        homeViewController.collectionView.reloadData()
                                    }
                                    mainStore.save(podcastItem: caster)
                                }
                            }
                            homeViewController.dataSource.items = results
                            guard let urlString = homeViewController.dataSource.items[0].podcastArtUrlString else { return }
                            guard let imageUrl = URL(string: urlString) else { return }
                            homeViewController.topView.podcastImageView.downloadImage(url: imageUrl)
                        }
                    }
                }
            }
        }
    }
}


