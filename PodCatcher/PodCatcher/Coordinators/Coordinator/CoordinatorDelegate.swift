//
//  CoordinatorDelegate.swift
//  PodCatcher
//
//  Created by Christopher Webb-Orenstein on 1/4/18.
//  Copyright © 2018 Christopher Webb-Orenstein. All rights reserved.
//

import Foundation

protocol CoordinatorDelegate: class {
    func transitionCoordinator(type: CoordinatorType)
    func updatePodcast(with playlistId: String)
    func podcastItem(toAdd: PodcastItem, with index: Int)
   // func addItemToPlaylist(podcastPlaylist: PodcastPlaylist)
}
