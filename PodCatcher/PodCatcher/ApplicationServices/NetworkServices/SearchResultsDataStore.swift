import UIKit

struct SearchResultsIteractor {
    
    var searchTerm: String? = ""
    var lookup: String? = ""
    
    mutating func setSearch(term: String?) {
        searchTerm = term
    }
    
    mutating func setLookup(term: String?) {
        lookup = term
    }
    
    func searchForTracksFromLookup(completion: @escaping (_ results: [JSON?]? , _ error: Error?) -> Void) {
        NetworkService.search(forLookup: lookup) { response in
            switch response {
            case .success(let data):
                guard let data = data else { return }
                let resultsData = data["results"] as? [[String: Any]?]?
                DispatchQueue.main.async {
                    guard let resultsData = resultsData else { return }
                    completion(resultsData, nil)
                }
            case .failed(let error):
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
    }
    
    func searchForTracks(completion: @escaping (_ results: [Podcast]? , _ error: Error?) -> Void) {
        guard let searchTerm = searchTerm else { return }
        NetworkService.search(for: searchTerm) { response in
            switch response {
            case .success(let data):
                guard let data = data else { return }
                let resultsData = data["results"] as? [[String: Any]?]?
                if let resultsData = resultsData {
                    var results = [Podcast]()
                    resultsData?.forEach { resultingData in
                        guard let resultingData = resultingData else { return }
                        if let caster = Podcast(json: resultingData) {
                            results.append(caster)
                        }
                    }
                    DispatchQueue.main.async {
                        completion(results, nil)
                    }
                }
            case .failed(let error):
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
    }
}


struct SearchResultsDataStore {
    
    func pullFeed(for podCast: String, competion: @escaping (([Episodes]?, Error?) -> Void)) {
        var episodes = [Episodes]()
        RSSFeedAPIClient.requestFeed(for: podCast) { rssData, error in
            if let error = error {
                DispatchQueue.main.async {
                    competion(nil, error)
                }
            }
            guard let rssData = rssData else { return }
            for data in rssData {
                
                guard let title = data["title"] else { continue }
                guard let audioUrl = data["audio"] else { continue }
                var episode = Episodes()
                    
//                    // Episode(mediaUrlString: audioUrl,
//                                      audioUrlSting: audioUrl,
//                                      title: title,
//                                      podcastTitle: "",
//                                      date: "",
//                                      description: "",
//                                      duration: 000,
//                                      audioUrlString: audioUrl,
//                                      stringDuration: "",
//                                      tags: [])
                
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
                    //episode
                    episode.podcastTitle = collectionName
                    print("collection name")
                    //print(collectionName)
                }
                
                if data["artistName"] != nil {
                    print("artistName")
                    // /print(artistName)
                }
                
                if data["primaryGenreName"] != nil {
                    print("PRIMARY GENRE")
                    // print(primaryGenre)
                }
                
                if data["artistViewUrl"] != nil {
                    print("itunes url")
                    //print(artistViewUrl)
                }
                
                if data["country"] != nil {
                    print("country")
                    //  print(country)
                }
                
                if let date = data["pubDate"] {
                    episode.date = date
                }
                
                if data["releaseDate"] != nil {
                    print("RELEASE DATE")
                    //print(releaseDate)
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
                
                if let genres = data["genres"] as? [String] {
                    for genre in genres {
                        let trimmedGenre = genre.trimmingCharacters(in: .whitespacesAndNewlines)
                        if !episode.tags.contains(trimmedGenre) {
                            episode.tags.append(trimmedGenre)
                        }
                    }
                }
                episodes.append(episode)
            }
            DispatchQueue.main.async {
                competion(episodes, nil)
            }
        }
    }
}

extension SearchResultsDataStore: ItemCreator {
    func pullFeedTopPodcasts(competion: @escaping (([TopItem]?, Error?) -> Void)) {
        RSSFeedAPIClient.getTopPodcasts { rssData, error in
            if let error = error {
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    competion(nil, error)
                }
            }
            guard let rssData = rssData else { return }
            DispatchQueue.main.async {
                competion(self.createItems(rssData: rssData), nil)
            }
        }
    }
}
