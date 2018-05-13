//
//  Podcast.swift
//  PodCatcher
//
//  Created by Christopher Webb on 5/12/18.
//  Copyright © 2018 Christopher Webb-Orenstein. All rights reserved.
//

import Foundation

class Podcast  {
    
    var podcastArtist: String
    var podcastArtUrlString: String
    var podcastTitle: String
    weak var store: Store?
    
    var episodes = [Episodes]()
    
    var category = ""
    var id: String
    
    var artistId: String
    var feedUrl: String
    var itunesUrlString: String
    var index: Int
    
    var tags: [String] = []
    
    init() {
        self.podcastArtist = "N/A"
        self.podcastArtUrlString = "N/A"
        self.podcastTitle = "N/A"
        self.episodes = [Episodes]()
        self.category = ""
        self.id = ""
        self.artistId = ""
        self.feedUrl = ""
        self.itunesUrlString = ""
        self.index = 0
        self.tags = []
    }
    
    convenience init(podcastArtist: String, feedUrl: String, podcastArtUrlString: String, artistId: String, id: String, podcastTitle: String) {
        self.init()
        self.podcastArtist = podcastArtist
        self.feedUrl = feedUrl
        self.artistId = artistId
        self.id = id
        self.podcastTitle = podcastTitle
    }
    
    convenience init(podcastArtist: String, feedUrl: String, podcastArtUrlString: String, artistId: String, id: String, podcastTitle: String, episodes: [Episodes]) {
        self.init(podcastArtist: podcastArtist, feedUrl: feedUrl, podcastArtUrlString: podcastArtUrlString, artistId: artistId, id: id, podcastTitle: podcastTitle)
        self.podcastArtist = podcastArtist
        self.feedUrl = feedUrl
        self.podcastArtUrlString = podcastArtUrlString
        self.artistId = artistId
        self.id = id
        self.podcastTitle = podcastTitle
        self.episodes = episodes
    }
    
    convenience init(podcastArtist: String, feedUrl: String, podcastArtUrlString: String, artistId: String, id: String, podcastTitle: String, episodes: [Episodes], category: String) {
        self.init(podcastArtist: podcastArtist, feedUrl: feedUrl, podcastArtUrlString: category, artistId: artistId, id: id, podcastTitle: podcastTitle, episodes: episodes)
        self.podcastArtist = podcastArtist
        self.feedUrl = feedUrl
        self.artistId = artistId
        self.id = id
        self.podcastTitle = podcastTitle
        self.episodes = episodes
    }
    
    init?(json: [String: Any]) {
        let list = ["Joe Rogan", "HowStuffWorks", "ESPN, ESPN Films, 30for30", "Matt Behdjou", "Mike & Matt", "Tenderfoot", "Mathis Entertainment, Inc."]
        guard !list.contains(json["artistName"] as! String) else { return nil }
        guard let artUrl = json["artworkUrl600"] as? String else { return nil }
        guard let artistName = json["artistName"] as? String else { return nil }
        guard (json["trackName"] as? String) != nil else { return nil }
        guard let title = json["collectionName"] as? String else { return nil}
        guard (json["releaseDate"] as? String) != nil else { return nil }
        guard let id = json["collectionId"] as? Int else { return nil }
        guard let feedUrl = json["feedUrl"] as? String else { return nil}
        
        self.podcastArtUrlString = artUrl
        self.podcastArtist = artistName
        self.podcastTitle = title
        self.feedUrl = feedUrl
        self.id = String(describing: id)
        
        if let artistId = json["artistId"] as? Int {
            self.artistId = String(describing: artistId)
        } else {
            self.artistId = "N/A"
        }
        if let genres = json["genres"] as? [String] {
            for genre in genres {
                let trimmedGenre = genre.trimmingCharacters(in: .whitespacesAndNewlines)
                if !tags.contains(trimmedGenre) {
                    tags.append(trimmedGenre)
                }
            }
        }
        self.index = 0
        if let collectionName = json["collectionName"] as? String {
            self.podcastTitle = collectionName
        } else {
            self.podcastTitle = "N/A"
        }
        
        if let artistName = json["artistName"] as? String {
            self.podcastArtist = artistName
        }
        
        if let primaryGenre = json["primaryGenreName"] as? String {
            self.category = primaryGenre
        }
        
        if let artistViewUrl = json["artistViewUrl"] as? String {
            self.itunesUrlString = artistViewUrl
        } else {
            self.itunesUrlString = "N/A"
        }
        
        if (json["country"] as? String) != nil {
            //  print(country)
        }
    }
}

extension Podcast: Equatable {
    
    static func ==(lhs: Podcast, rhs: Podcast) -> Bool {
        if lhs.id == rhs.id {
            return true
        } else if lhs.podcastArtUrlString == rhs.podcastArtUrlString {
            return true
        }
        
        return false
        //return lhs.id == rhs.id
    }
    
    var providerId: String {
        return self.id
    }
    
    func nsTags() -> [NSString] {
        var nsTags = [NSString]()
        
        for tag in tags {
            print(tag)
            nsTags.append(tag as NSString)
        }
        return nsTags
    }
}


extension Podcast: Hashable {
    var hashValue: Int {
        return "\(feedUrl)\(podcastArtUrlString)".hashValue
    }
}

extension Podcast {
    func updateEpisodesOnBackground() {
        let store = SearchResultsDataStore()
        DispatchQueue.global(qos: .background).async {
            //            store.pullFeed(for: self.feedUrl, with: self.podcastArtist) { response, error  in
            //                guard let episodes = response else { return }
            //                DispatchQueue.main.async {
            //                    self.episodes = episodes
            //                }
            //            }
        }
    }
}
