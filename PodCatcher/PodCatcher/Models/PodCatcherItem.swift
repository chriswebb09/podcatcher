//
//  PodCatcherItem.swift
//  PodCatcher
//
//  Created by Christopher Webb-Orenstein on 6/5/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit
import MediaPlayer

struct MediaCatcherItem {
    var creatorName: String
    var title: String
    var playtime: Double
    var playCount: Int?
    var collectionName: String
    var audioUrl: URL?
    var audioItem: MPMediaItem?
    var tags: [String]
    
    init(creatorName: String, title: String, playtime: Double, playCount: Int, collectionName: String, audioUrl: URL) {
        self.creatorName = creatorName
        self.title = title
        self.playtime = playtime
        self.collectionName = collectionName
        self.audioUrl = audioUrl
        self.tags = []
    }
}

extension MediaCatcherItem: Equatable {

    static func ==(lhs: MediaCatcherItem, rhs: MediaCatcherItem) -> Bool {
        return lhs.audioUrl == rhs.audioUrl
    }
}
