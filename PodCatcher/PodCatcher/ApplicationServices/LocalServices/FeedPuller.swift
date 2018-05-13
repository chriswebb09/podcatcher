//
//  FeedPuller.swift
//  PodCatcher
//
//  Created by Christopher Webb on 5/12/18.
//  Copyright © 2018 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

protocol FeedPuller: RSSFeedParser {
    func pullFeed(for podCast: String, with name: String, competion: @escaping (([Episodes]?, Error?) -> Void))
}

extension FeedPuller {
    
    func pullFeed(for podCast: String, with name: String, competion: @escaping (([Episodes]?, Error?) -> Void)) {
        RSSFeedAPIClient.requestFeed(for: podCast) { rssData, error in
            if let error = error {
                DispatchQueue.main.async {
                    competion(nil, error)
                }
            }
            guard let rssData = rssData else { return }
            let episodes = self.parse(rssData: rssData, for: name)
            competion(episodes, nil)
        }
    }
}
