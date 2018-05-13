//
//  MiniPlayerDelegate.swift
//  PodCatcher
//
//  Created by Christopher Webb on 5/12/18.
//  Copyright © 2018 Christopher Webb-Orenstein. All rights reserved.
//

import Foundation

protocol MiniPlayerDelegate: class {
    func expandPodcast(episode: Episodes)
    func expandPodcast(episode: Episode)
    func playButton(tapped: Bool)
    func pauseButton(tapped: Bool)
}
