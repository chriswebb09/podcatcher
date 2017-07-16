import UIKit


extension PlaylistsTabCoordinator: PlaylistsViewControllerDelegate {
    
    func didAssignPlaylist(with id: String) {
        delegate?.updatePodcast(with: id)
        print(id)
        let controller = navigationController.viewControllers.last as! PlaylistsViewController
        navigationController.setNavigationBarHidden(false, animated: false)
        controller.tabBarController?.selectedIndex = 2
    }

    func logout(tapped: Bool) {
        if dataSource.user != nil {
            dataSource.user = nil
        }
        delegate?.transitionCoordinator(type: .app, dataSource: dataSource)
    }
    
    func didSelect(at index: Int, with playlist: Playlist) {
        let playlistViewController = PlaylistViewController(index: index)
        playlistViewController.delegate = self
        playlistViewController.caster.podcastTitle = playlist.name
        navigationController.viewControllers.append(playlistViewController)
    }
}

extension PlaylistsTabCoordinator: PlaylistViewControllerDelegate {
    
    func didSelectPodcast(at index: Int, with episodes: [PodcastPlaylistItem], caster: CasterSearchResult) {
        let playerView = PlayerView()
        let playerViewController = PlayerViewController(index: index, caster: caster, user: dataSource.user)
        playerViewController.delegate = self
        navigationController.navigationBar.isTranslucent = true
        navigationController.viewControllers.append(playerViewController)
    }
}

extension PlaylistsTabCoordinator: PlayerViewControllerDelegate {
    
    func addItemToPlaylist(item: CasterSearchResult, index: Int) {
        
    }
    
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
        navigationController.setNavigationBarHidden(false, animated: false)
        navigationController.viewControllers.last?.tabBarController?.tabBar.alpha = 1
    }
    
    func addItemToPlaylist(item: PodcastPlaylistItem) {
        
    }
}
