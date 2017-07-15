import UIKit


extension PlaylistsTabCoordinator: PlaylistsViewControllerDelegate {
    
    func didAssignPlaylist(with id: String) {
        delegate?.updatePodcast(with: id)
        print(id)
        let controller = navigationController.viewControllers.last as! PlaylistsViewController
        navigationController.setNavigationBarHidden(false, animated: false)
        controller.tabBarController?.selectedIndex = 2
    }
    
    
    func didAssignPlaylist(playlist: PodcastPlaylist) {
        
    }
    
    func didAssign(podcast: PodcastPlaylistItem) {
        
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
        navigationController.viewControllers.append(playlistViewController)
    }
}

extension PlaylistsTabCoordinator: PlaylistViewControllerDelegate {
    
    func didSelectPodcast(at index: Int, with episodes: [PodcastPlaylistItem], caster: CasterSearchResult) {
        let playerView = PlayerView()
        // var homeVC = navigationController.viewControllers[0] as! HomeViewController
        //   var playerPodcast = podcast
        //        CALayer.createGradientLayer(with: [UIColor(red:0.94, green:0.31, blue:0.81, alpha:1.0).cgColor, UIColor(red:0.32, green:0.13, blue:0.70, alpha:1.0).cgColor], layer: playerView.backgroundView.layer, bounds: UIScreen.main.bounds)
        //playerPodcast.episodes = episodes
        print(caster)
        let playerViewController = PlayerViewController(index: index, caster: caster, user: dataSource.user)
        //        // playerViewController.dataSource.currentPlaylistId = homeVC.currentPlaylistId
        playerViewController.delegate = self
        navigationController.navigationBar.isTranslucent = true
        //        navigationController.navigationBar.alpha = 0
        //        // controller?.tabBarController?.selectedIndex = 1
        navigationController.viewControllers.append(playerViewController)
        //        //  PodcastPlaylistItem
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
