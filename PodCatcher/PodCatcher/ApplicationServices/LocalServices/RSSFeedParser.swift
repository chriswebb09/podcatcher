//
//  RSSFeedParser.swift
//  PodCatcher
//
//  Created by Christopher Webb on 5/12/18.
//  Copyright © 2018 Christopher Webb-Orenstein. All rights reserved.
//

import Foundation


protocol RSSFeedParser {
    func parse(rssData: [[String : String]], for name: String) -> [Episodes]
}

extension RSSFeedParser {
    
    func parse(rssData: [[String : String]], for name: String) -> [Episodes] {
        var episodes = [Episodes]()
        for data in rssData {
            
            guard let title = data["title"] else { continue }
            guard let audioUrl = data["audio"] else { continue }
            
            var episode = Episodes(mediaUrlString: audioUrl,
                                   title: title,
                                   subtitle: "",
                                   summary: "",
                                   podcastTitle: "",
                                   podcastArtistName: "",
                                   date: "",
                                   description: "",
                                   duration: 000,
                                   podcastArtUrlString: "", favorite: false,
                                   stringDuration: "",
                                   tags: [])
            
            if var duration = data["itunes:duration"] {
                duration = duration.replacingOccurrences(of: "00:",
                                                         with: "",
                                                         options: NSString.CompareOptions.literal,
                                                         range: nil)
                if !duration.contains(":") {
                    duration = String.constructTimeString(time: Double(duration)!)
                }
                episode.stringDuration = duration
            }
            if let description = data["itunes:summary"] {
                episode.description = description
            }
            
            if let collectionName = data["collectionName"] {
                episode.podcastTitle = collectionName
            }
            
            if let artistName = data["artistName"] {
                episode.podcastArtistName = artistName
            } else {
                episode.podcastArtistName = name
            }
            
            if data["primaryGenreName"] != nil {
                print("PRIMARY GENRE")
            }
            
            if data["artistViewUrl"] != nil {
                print("itunes url")
            }
            
            if data["country"] != nil {
                print("country")
            }
            
            if let date = data["pubDate"] {
                episode.date = date
            }
            
            if data["releaseDate"] != nil {
                print("RELEASE DATE")
            }
            
            if let subtitle = data["tunes:subtitle"] {
                episode.subtitle = subtitle
            }
            
            if let summary = data["itunes:summary"] {
                episode.summary = summary
            }
            
            if let duration = data["bytes"] {
                episode.byteString = duration
            }
            
            if let keywords = data["itunes:keywords"] {
                let tags = keywords.components(separatedBy: ",")
                for tag in tags {
                    let trimmedTag = tag.trimmingCharacters(in: .whitespacesAndNewlines)
                    if !episode.tags.contains(trimmedTag) {
                        episode.tags.append(trimmedTag)
                    }
                }
            }
            
            if let genres = [data["genres"]] as? [String] {
                for genre in genres {
                    let trimmedGenre = genre.trimmingCharacters(in: .whitespacesAndNewlines)
                    if !episode.tags.contains(trimmedGenre) {
                        episode.tags.append(trimmedGenre)
                    }
                }
            }
            episode.podcastArtistName = name
            episodes.append(episode)
        }
        print(episodes)
        return episodes
    }
}
