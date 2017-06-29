import Foundation

class RSSFeedAPIClient: NSObject, XMLParserDelegate {
    
    static func requestFeed(for urlString: String, completion: @escaping ([[String: String]]?, Error?) -> Void) {
        guard let url = URL(string: urlString) else { return }
        URLSession(configuration: .ephemeral).dataTask(with: URLRequest(url: url)) { data, response, error in
            if let error = error {
                completion(nil, error)
            } else {
                guard let data = data else { return }
                let rssParser = RSSParser()
                rssParser.parseResponse(data: data) { parsedRSS in
                    completion(parsedRSS, nil)
                }
            }
            }.resume()
    }
}

class SearchResultsDataStore {
    
    func pullFeed(for podCast: String, competion: @escaping (([Episodes]?, Error?) -> Void)) {
        var episodes = [Episodes]()
        RSSFeedAPIClient.requestFeed(for: podCast) { rssData, error in
            if let error = error {
                competion(nil, error)
            }
            guard let rssData = rssData else { return }
            for data in rssData {
                guard let title = data["title"] else { continue }
                guard let audioUrl = data["audio"] else { continue }
                var episode = Episodes(title: title, date: "", description: "", duration: 000, audioUrlString: audioUrl, stringDuration: "")
                if let duration = data["itunes:duration"] {
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
            competion(episodes, nil)
        }
    }
}

