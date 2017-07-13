import UIKit

class SearchResultsDataStore {
    
    func pullFeed(for podCast: String, competion: @escaping (([Episodes]?, Error?) -> Void)) {
        var episodes = [Episodes]()
        RSSFeedAPIClient.requestFeed(for: podCast) { rssData, error in
            if let error = error {
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    competion(nil, error)
                }
            }
            guard let rssData = rssData else { return }
            for data in rssData {
                guard let title = data["title"] else { continue }
                guard let audioUrl = data["audio"] else { continue }
                var episode = Episodes(mediaUrlString: audioUrl, audioUrlSting: audioUrl, title: title, date: "", description: "", duration: 000, audioUrlString: audioUrl, stringDuration: "")
                if var duration = data["itunes:duration"] {
                    print("DURATION")
                    duration = duration.replacingOccurrences(of: "00:", with: "", options: NSString.CompareOptions.literal, range: nil)
                    if !duration.contains(":") {
                        duration = String.constructTimeString(time: Double(duration)!)
                    }
                    episode.stringDuration = duration
                }
                if let description = data["itunes:summary"] {
                    print("SUMMARY")
                    episode.description = description
                }
                if let date = data["pubDate"] {
                    print("PUBDATE")
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

//public extension String {
//    
//    func stringByReplacingFirstOccurrenceOfString(target: String, withString replaceString: String) -> String {
//        if let range = self.range(of: target) {
//            return self.string
//        }
////        if let range = self.rangeOfString(target) {
////            return self.stringByReplacingCharactersInRange(range, withString: replaceString)
////        }
//        return self
//    }
//    
//}
//
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
