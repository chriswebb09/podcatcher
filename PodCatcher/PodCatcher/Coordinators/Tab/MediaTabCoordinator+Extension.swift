//
//  MediaTabCoordinator+Extension.swift
//  PodCatcher
//
//  Created by Christopher Webb-Orenstein on 6/7/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

extension MediaTabCoordinator: MediaControllerDelegate {
    
    func logoutTapped(logout: Bool) {
        print("tapped")
        if dataSource.user != nil {
            dataSource.user = nil
        }
        delegate?.transitionCoordinator(type: .app, dataSource: dataSource)
    }
    
    func didSelectCaster(at index: Int, with playlist: Caster) {
        let podcastList = PodcastListViewController()
        podcastList.caster = playlist
        podcastList.dataSource = dataSource
        podcastList.delegate = self
        navigationController.viewControllers.append(podcastList)
        print("selected")
    }
}

extension MediaTabCoordinator: PodcastListViewControllerDelegate {
    
    func didSelectPodcastAt(at index: Int, with podcast: Caster) {
        let playerView = PlayerView()
        let playerViewController = PlayerViewController(playerView: playerView, index: index, caster: podcast, user: dataSource.user)
        navigationController.viewControllers.append(playerViewController)
        print("selected")
    }
}
