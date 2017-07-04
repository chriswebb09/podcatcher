import UIKit

class HomeDataStore {
    var categories: [String] = []
    var lookup: String = ""
    var items = [TopItem]()
    var response = [TopItem]()
    
    var politicsItems = [CasterSearchResult]()
    
    
    var historyItems = [CasterSearchResult]() {
        didSet {
            dump(historyItems)
        }
    }
    
    func pullFeedTopPodcasts(competion: @escaping (([TopItem]?, Error?) -> Void)) {
        RSSFeedAPIClient.getTopPodcasts { rssData, error in
            if let error = error {
                competion(nil, error)
            }
            guard let rssData = rssData else { return }
            for data in rssData {
                guard let category = data["category"] else { return }
                let link = data["link"]
                let pubDate = data["pubDate"]
                let title = data["title"]
                if let itemLink = link, let id = self.extractIdFromLink(link: itemLink), let date = pubDate, let title = title {
                    let index = id.index(id.startIndex, offsetBy: 2)
                    let item = TopItem(title: title, id: id.substring(from: index), pubDate: date, category: category, itunesLinkString: itemLink)
                    self.items.append(item)
                    
                }
                DispatchQueue.main.async {
                    competion(self.items, nil)
                }
            }
        }
    }
    
    func getResults(from items:[TopItem]) {
        
        for item in items  {
            if item.category == "News&Politics" {
                lookup = item.id
                self.searchForTracks { result in
                    guard let result = result.0 else { return }
                    self.politicsItems.append(contentsOf: result)
                }
            } else if item.category == "History" {
                lookup = item.id
                self.searchForTracks { result in
                    guard let result = result.0 else { return }
                    self.historyItems.append(contentsOf: result)
                    dump(self.historyItems)
                }
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
    
    func searchForTracks(completion: @escaping (_ results: [CasterSearchResult]? , _ error: Error?) -> Void) {
        iTunesAPIClient.search(forLookup: lookup) { response in
            switch response {
            case .success(let data):
                let resultsData = data["results"] as! [[String: Any]]
                let results = ResultsParser.parse(resultsData: resultsData)
                DispatchQueue.main.async {
                    completion(results, nil)
                }
                
            case .failed(let error):
                completion(nil, error)
            }
        }
    }
}
