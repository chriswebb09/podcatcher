import Foundation

class RSSFeedAPIClient: NSObject {
    
    static func requestFeed(for urlString: String, completion: @escaping ([[String: String]]?, Error?) -> Void) {
        guard let url = URL(string: urlString) else { return }
        let nprParse = ["344098539", "510298", "510200", "510318", "510208", "510282", "500005", "510307", "510322", "510308", "510310", "510019", "510313", "510289", "381444908", "510299"]
        URLSession(configuration: .ephemeral).dataTask(with: URLRequest(url: url)) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            } else {
                guard let data = data else { return }
                if urlString.hasPrefix("https://www.npr.org/rss/podcast.php") {
                    for npr in nprParse {
                        if urlString.hasSuffix(npr) {
                            let rssParser = NPRParser()
                            rssParser.recordKey = "item"
                            rssParser.dictionaryKeys = ["itunes:new-feed-url", "itunes:summary", " itunes:author", "tunes:subtitle", "pubDate", "enclosure", "itunes:duration", "title", "audio/mp3", "audio/mpeg", "itunes:keywords", "itunes:image", "category", "itunes:author", "itunes:summary", "description", "enclosure"]
                            rssParser.parseResponse(data) { parsedRSS in
                                DispatchQueue.main.async {
                                    completion(parsedRSS, nil)
                                }
                            }
                        }
                    }
                } else {
                    let rssParser = RSSParser()
                    rssParser.parseResponse(data) { parsedRSS in
                        DispatchQueue.main.async {
                            completion(parsedRSS, nil)
                        }
                    }}
            }}.resume()
    }
}

extension RSSFeedAPIClient: XMLParserDelegate {
    
    static func getTopPodcasts(completion: @escaping ([[String: String]]?, Error?) -> Void) {
        guard let url = URL(string: "https://rss.itunes.apple.com/api/v1/us/podcasts/top-podcasts/40/explicit/xml") else { return }
        URLSession(configuration: .ephemeral).dataTask(with: URLRequest(url: url)) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            } else {
                guard let data = data else { return }
                let rssParser = RSSParser()
                rssParser.parseResponse(data) { parsedRSS in
                    DispatchQueue.main.async {
                        completion(parsedRSS, nil)
                    }
                }
            }}.resume()
    }
}
