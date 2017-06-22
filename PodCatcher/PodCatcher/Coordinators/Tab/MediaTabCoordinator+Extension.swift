import UIKit

extension MediaTabCoordinator: MediaControllerDelegate {
    
    func didSelect(at index: Int) {
        let podcastList = PodcastListViewController(index: index, dataSource: dataSource)
        podcastList.caster = dataSource.casters[index]
        podcastList.delegate = self
        navigationController.viewControllers.append(podcastList)
    }

    
    func logoutTapped(logout: Bool) {
        if dataSource.user != nil {
            dataSource.user = nil
        }
        delegate?.transitionCoordinator(type: .app, dataSource: dataSource)
    }
}

extension MediaTabCoordinator: PodcastListViewControllerDelegate {
    
    func didSelectPodcastAt(at index: Int, with podcast: Caster) {
        let playerView = PlayerView()
        let playerViewController = PlayerViewController(playerView: playerView, index: index, caster: podcast, user: dataSource.user)
        playerViewController.delegate = self
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
}
