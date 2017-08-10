import UIKit

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
                var episode = Episodes(mediaUrlString: audioUrl,
                                       audioUrlSting: audioUrl,
                                       title: title,
                                       date: "",
                                       description: "",
                                       duration: 000,
                                       audioUrlString: audioUrl,
                                       stringDuration: "")
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
                if let date = data["pubDate"] {
                    episode.date = date
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
