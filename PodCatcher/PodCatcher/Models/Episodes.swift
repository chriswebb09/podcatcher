//
//  Episodes.swift
//  PodCatcher
//
//  Created by Christopher Webb on 5/13/18.
//  Copyright © 2018 Christopher Webb-Orenstein. All rights reserved.
//

import Foundation

import UIKit

struct Episodes {
    
    weak var store: Store?
    
    var mediaUrlString: String
    var title: String
    var subtitle: String
    var podcastTitle: String
    var podcastArtistName: String
    var summary: String
    var duration: Double
    var date: String
    var description: String
    var podcastArtUrlString: String
    var byteString: String?
    var favorite: Bool
    var stringDuration: String?
    var tags: [String] = []
    
    init() {
        self.mediaUrlString = ""
        self.title = ""
        self.podcastArtistName = ""
        self.podcastTitle = ""
        self.date = ""
        self.description = ""
        self.duration  = 0
        self.podcastArtUrlString = ""
        self.favorite = false
        self.subtitle = ""
        self.summary = ""
    }
    
    init(mediaUrlString: String,
         title: String,
         subtitle: String,
         summary: String,
         podcastTitle: String,
         podcastArtistName: String,
         date: String,
         description: String,
         duration: Double,
         podcastArtUrlString: String,
         favorite: Bool,
         stringDuration: String?,
         tags: [String]) {
        self.mediaUrlString = mediaUrlString
        self.title = title
        self.podcastTitle = podcastTitle
        self.podcastArtistName = podcastArtistName
        self.date = date
        self.description = description
        self.duration = duration
        self.podcastArtUrlString = podcastArtUrlString
        self.favorite = favorite
        self.stringDuration = stringDuration
        self.tags = tags
        self.subtitle = subtitle
        self.summary = summary
    }
}

//extension Episodes: Equatable {
//    static func ==(lhs: Episodes, rhs: Episodes) -> Bool {
//        return lhs.mediaUrlString == rhs.mediaUrlString
//    }
//}

extension Episodes: MediaItem {
    var mediaString: String {
        get {
            return self.mediaUrlString
        }
        set {
            self.mediaUrlString = newValue
        }
    }
}
