import Foundation

class RSSFeedAPIClient: NSObject {
    
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
                rssParser.parseResponse(data) { parsedRSS in
                    DispatchQueue.main.async {
                        completion(parsedRSS, nil)
                    }
                }
            }
            }.resume()
    }
}

extension RSSFeedAPIClient: XMLParserDelegate {
    
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
                rssParser.parseResponse(data) { parsedRSS in
                    DispatchQueue.main.async {
                        completion(parsedRSS, nil)
                    }
                }
            }
            }.resume()
    }
}
