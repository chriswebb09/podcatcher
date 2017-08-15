import UIKit

class RSSFeedAPIClient: NSObject {
    
    static func processNPR(urlString: String, data: Data, completion: @escaping ([[String: String]]?) -> Void) {
        let nprParse = ["344098539", "510298", "510200", "510318", "510208", "510282", "500005", "510307", "510322", "510308", "510310", "510019", "510313", "510289", "381444908", "510299", "510324"]
        for npr in nprParse {
            if urlString.hasSuffix(npr) {
                let rssParser = NPRParser()
                rssParser.recordKey = "item"
                rssParser.dictionaryKeys = ["itunes:new-feed-url", "itunes:summary", " itunes:author", "tunes:subtitle", "pubDate", "enclosure", "itunes:duration", "title", "audio/mp3", "audio/mpeg", "itunes:keywords", "itunes:image", "category", "itunes:author", "itunes:summary", "description", "enclosure"]
                rssParser.parseResponse(data) { parsedRSS in
                    DispatchQueue.main.async {
                        completion(parsedRSS)
                    }
                }
            }
        }
    }
    
    static func requestFeed(for urlString: String, completion: @escaping ([[String: String]]?, Error?) -> Void) {
        guard let url = URL(string: urlString) else { return }
        URLSession(configuration: .ephemeral).dataTask(with: URLRequest(url: url)) { data, response, error in
            guard let data = data else { return }
            if let error = error {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            } else {
                if urlString.hasPrefix("https://www.npr.org/rss/podcast.php") {
                    RSSFeedAPIClient.processNPR(urlString: urlString, data: data) { processedResponse in
                        completion(processedResponse, nil)
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
        guard let url = URL(string: "https://rss.itunes.apple.com/api/v1/us/podcasts/top-podcasts/25/explicit/xml") else { return }
        
        let urlconfig = URLSessionConfiguration.ephemeral
        urlconfig.timeoutIntervalForRequest = 8
        urlconfig.timeoutIntervalForResource = 8
        let session = URLSession(configuration: urlconfig, delegate: nil, delegateQueue: nil)
        let request = URLRequest(url: url,  cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 8)
        session.dataTask(with: request) { data, response, error in
            if let error = error {
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
