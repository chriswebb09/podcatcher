import UIKit

typealias JSON = [String : Any]

enum Response {
    case success(JSON?), failed(Error)
}

enum URLRouter {
    
    case base, path
    
    var url: String {
        switch self {
        case .base:
            return "https://itunes.apple.com"
        case .path:
            return "/search?country=US&media=podcast&limit=15&term="
            
        }
    }
}

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

final class iTunesAPIClient {
    
    static func search(for query: String, completion: @escaping (Response) -> Void) {
        guard let url = build(searchTerm: query) else { return }
        URLSession(configuration: .ephemeral).dataTask(with: URLRequest(url: url)) { data, response, error in
            if let error = error {
                completion(.failed(error))
            } else {
                do {
                    guard let data = data else { return }
                    guard let responseObject = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else { return }
                    DispatchQueue.main.async {
                        completion(.success(responseObject))
                    }
                }
            }}.resume()
    }
    
    static func search(forLookup: String?, completion: @escaping (Response) -> Void) {
        guard let forLookup = forLookup else { return }
        guard let url = URL(string: "https://itunes.apple.com/lookup?id=\(forLookup)&entity=podcast&limit=15") else { return }
        URLSession(configuration: .ephemeral).dataTask(with: URLRequest(url: url)) { data, response, error in
            if let error = error {
                completion(.failed(error))
            } else {
                do {
                    guard let data = data else { return }
                    guard let responseObject = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else { return }
                    DispatchQueue.main.async {
                        completion(.success(responseObject))
                    }
                }
            }}.resume()
    }
    
    static func build(searchTerm: String) -> URL? {
        guard let encodedQuery = searchTerm.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return nil }
        let urlString = URLRouter.base.url + URLRouter.path.url + encodedQuery
        print(urlString)
        return URL(string: urlString)
    }
}
