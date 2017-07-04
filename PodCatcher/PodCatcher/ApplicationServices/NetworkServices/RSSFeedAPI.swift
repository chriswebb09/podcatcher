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
    
    static func getTopPodcasts(completion: @escaping ([[String: String]]?, Error?) -> Void) {
        guard let url = URL(string: "https://rss.itunes.apple.com/api/v1/us/podcasts/top-podcasts/25/explicit/xml") else { return }
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
    
    func pullFeedTopPodcasts(competion: @escaping (([TopItem]?, Error?) -> Void)) {
        var items = [TopItem]()
        RSSFeedAPIClient.getTopPodcasts { rssData, error in
            if let error = error {
                competion(nil, error)
            }
            guard let rssData = rssData else { return }
            for data in rssData {
                let link = data["link"]
                let pubDate = data["pubDate"]
                let title = data["title"]
                let category = data["category"]
                if let itemLink = link, let id = self.extractIdFromLink(link: itemLink), let date = pubDate, let title = title, let category = category {
                    var itemCategory = "N/A"
                    if category != "podcast" {
                        itemCategory = category
                    }
                    let index = id.index(id.startIndex, offsetBy: 2)
                    
                    let item = TopItem(title: title, id: id.substring(from: index), pubDate: date, category: itemCategory, itunesLinkString: itemLink)
                    items.append(item)
                }
            }
            DispatchQueue.main.async {
                competion(items, nil)
            }
            
        }
    }
    
    func extractIdFromLink(link: String) -> String? {
        let pattern = "id([0-9]+)"
        guard let regExp = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive) else {
            return nil
        }
        let nsLink = link as NSString
        let options = NSRegularExpression.MatchingOptions(rawValue: 0)
        let range = NSRange(location: 0, length: nsLink.length)
        let matches = regExp.matches(in: link as String, options:options, range:range)
        if let firstMatch = matches.first {
            return nsLink.substring(with: firstMatch.range)
        }
        return nil
    }
}

