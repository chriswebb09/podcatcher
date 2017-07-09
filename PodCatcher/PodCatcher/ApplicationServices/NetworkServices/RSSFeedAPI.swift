import Foundation

class RSSFeedAPIClient: NSObject, XMLParserDelegate {
    
    static func requestFeed(for urlString: String, completion: @escaping ([[String: String]]?, Error?) -> Void) {
        guard let url = URL(string: urlString) else { return }
        URLSession(configuration: .ephemeral).dataTask(with: URLRequest(url: url)) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
                DispatchQueue.main.async {
                     completion(nil, error)
                }
               
            } else {
                guard let data = data else { return }
                dump(data)
                let rssParser = RSSParser()
                rssParser.parseResponse(data: data) { parsedRSS in
                    DispatchQueue.main.async {
                        completion(parsedRSS, nil)
                    }
                }
            }
            }.resume()
    }
    
    static func getTopPodcasts(completion: @escaping ([[String: String]]?, Error?) -> Void) {
        guard let url = URL(string: "https://rss.itunes.apple.com/api/v1/us/podcasts/top-podcasts/25/explicit/xml") else { return }
        URLSession(configuration: .ephemeral).dataTask(with: URLRequest(url: url)) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            } else {
                dump(data)
                guard let data = data else { return }
                let rssParser = RSSParser()
                rssParser.parseResponse(data: data) { parsedRSS in
                    DispatchQueue.main.async {
                        completion(parsedRSS, nil)
                    }
                }
            }
            }.resume()
    }
}

class SearchResultsDataStore {
    
    func pullFeed(for podCast: String, competion: @escaping (([Episodes]?, Error?) -> Void)) {
        var episodes = [Episodes]()
        RSSFeedAPIClient.requestFeed(for: podCast) { rssData, error in
//            print(rssData)
            if let error = error {
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    competion(nil, error)
                }
                
            }
            guard let rssData = rssData else {
                return }
            
            for data in rssData {
                guard let title = data["title"] else { continue }
                guard let audioUrl = data["audio"] else { continue }
                var episode = Episodes(title: title, date: "", description: "", duration: 000, audioUrlString: audioUrl, stringDuration: "")
                if let duration = data["itunes:duration"] {
                    print("DURATION")
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
    
    func pullFeedTopPodcasts(competion: @escaping (([TopItem]?, Error?) -> Void)) {
        var items = [TopItem]()
        
        RSSFeedAPIClient.getTopPodcasts { rssData, error in
            
            if let error = error {
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    competion(nil, error)
                }
            }
            
            guard let rssData = rssData else { return }
            
            for data in rssData {
                
                let link = data["link"]
                let pubDate = data["pubDate"]
                let title = data["title"]
                let category = data["category"]
                if let itemLink = link, let id = String.extractID(from: itemLink), let date = pubDate, let title = title, let category = category {
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
}
