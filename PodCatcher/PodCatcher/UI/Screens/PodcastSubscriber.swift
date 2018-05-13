//
//  PodcastSubscriber.swift
//  PodCatcher
//
//  Created by Christopher Webb on 5/13/18.
//  Copyright © 2018 Christopher Webb-Orenstein. All rights reserved.
//

import Foundation

protocol PodcastSubscriber: class {
    var currentState: AudioState { get set }
    var currentPodcast: Episodes? { get set }
}
