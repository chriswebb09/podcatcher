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
