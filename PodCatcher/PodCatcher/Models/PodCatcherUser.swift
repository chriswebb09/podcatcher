//
//  PodCatcherUser.swift
//  PodCatcher
//
//  Created by Christopher Webb-Orenstein on 6/6/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

class PodCatcherUser {
    
    var username: String
    var emailAddress: String
    var totalTimeListening: TimeInterval?
    var customGenres: [String] = []
    var favoriteEpisodes: [String] = []
    
    init(username: String, emailAddress: String) {
        self.username = username
        self.emailAddress = emailAddress
    }
}
