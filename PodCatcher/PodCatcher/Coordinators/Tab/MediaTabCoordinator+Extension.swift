import UIKit

extension MediaTabCoordinator: MediaControllerDelegate {
    
    func logout(tapped: Bool) {
        if dataSource.user != nil {
            dataSource.user = nil
        }
        delegate?.transitionCoordinator(type: .app, dataSource: dataSource)
    }
    
    func didSelect(at index: Int, with caster: PodcastSearchResult) {
        let resultsList = SearchResultListViewController(index: index)
        resultsList.delegate = self
        resultsList.dataSource = dataSource
        resultsList.dataSource.user = dataSource.user
        resultsList.item = caster as! CasterSearchResult
        guard let feedUrlString = resultsList.item.feedUrl else { return }
        let store = SearchResultsDataStore()
        store.pullFeed(for: feedUrlString) { response in
            guard let episodes = response.0 else { print("no"); return }
            DispatchQueue.main.async {
                resultsList.episodes = episodes
                resultsList.collectionView.reloadData()
                self.navigationController.viewControllers.append(resultsList)
            }
        }
    }
}

extension MediaTabCoordinator: PodcastListViewControllerDelegate {
    
    func didSelectPodcastAt(at index: Int, podcast: CasterSearchResult, with episodes: [Episodes]) {
        let playerView = PlayerView()
        CALayer.createGradientLayer(with: [UIColor(red:0.94, green:0.31, blue:0.81, alpha:1.0).cgColor, UIColor(red:0.32, green:0.13, blue:0.70, alpha:1.0).cgColor], layer: playerView.backgroundView.layer, bounds: UIScreen.main.bounds)
        podcast.episodes = episodes
        let playerViewController = PlayerViewController(playerView: playerView, index: index, caster: podcast, user: dataSource.user)
        playerViewController.delegate = self
        navigationController.navigationBar.isTranslucent = true
        navigationController.navigationBar.alpha = 0
        navigationController.viewControllers.append(playerViewController)
    }
}

extension MediaTabCoordinator: PlayerViewControllerDelegate {
    
    func skipButton(tapped: Bool) {
        print("SkipButton tapped \(tapped)")
    }
    
    func pauseButton(tapped: Bool) {
        print("PauseButton tapped \(tapped)")
    }
    
    func playButton(tapped: Bool) {
        print("PlayButton tapped \(tapped)")
    }
    
    func navigateBack(tapped: Bool) {
        navigationController.navigationBar.alpha = 1
    }
}
