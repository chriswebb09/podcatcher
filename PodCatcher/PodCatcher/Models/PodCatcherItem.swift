//
//  PodCatcherItem.swift
//  PodCatcher
//
//  Created by Christopher Webb-Orenstein on 6/5/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

struct MediaCatcherItem {
    var creatorName: String
    var title: String
    var playtime: Double
    var playCount: Int?
    var collectionName: String
    var audioUrl: URL?
}

extension MediaCatcherItem: Equatable {

    static func ==(lhs: MediaCatcherItem, rhs: MediaCatcherItem) -> Bool {
        return lhs.audioUrl == rhs.audioUrl
    }
}
