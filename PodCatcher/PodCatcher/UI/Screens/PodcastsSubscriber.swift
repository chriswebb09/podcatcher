//
//  PodcastsSubscriber.swift
//  PodCatcher
//
//  Created by Christopher Webb on 5/13/18.
//  Copyright © 2018 Christopher Webb-Orenstein. All rights reserved.
//

import Foundation

protocol PodcastsSubscriber: class {
    var currentEpisode: Episode? { get set }
}
