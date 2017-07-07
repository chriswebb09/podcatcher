//
//  TrackCellViewModel.swift
//  PodCatcher
//
//  Created by Christopher Webb-Orenstein on 7/6/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import Foundation

struct TrackCellViewModel {
    
    var trackName: String
    var albumImageUrl: URL
    
    init(trackName: String, albumImageUrl: URL) {
        self.trackName = trackName
        self.albumImageUrl = albumImageUrl
    }
}
