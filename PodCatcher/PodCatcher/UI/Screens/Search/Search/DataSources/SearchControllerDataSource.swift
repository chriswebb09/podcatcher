import UIKit

class SearchControllerDataSource: NSObject {
    
    var store =  SearchResultsFetcher()
    var items = [PodcastSearchResult]()
    var viewShown: ShowView {
        if items.count > 0 {
            return .collection
        } else {
            return .empty
        }
    }
    var emptyView = NoSearchResultsView()
}

extension SearchControllerDataSource: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as SearchResultCell
        if items.count > 0 {
            if let title = items[indexPath.row].podcastTitle, let urlString = items[indexPath.row].podcastArtUrlString, let url = URL(string: urlString)  {
                cell.titleLabel.text = title
                cell.albumArtView.downloadImage(url: url)
                cell.layoutSubviews()
            }
        }
        return cell
    }
}

struct SearchResultsFetcher {
    
    var searchTerm: String? = ""
    var lookup: String? = ""
    
    mutating func setSearch(term: String?) {
        searchTerm = term
    }
    
    mutating func setLookup(term: String?) {
        lookup = term
    }
    
    func searchForTracksFromLookup(completion: @escaping (_ results: [[String: Any]?]? , _ error: Error?) -> Void) {
        iTunesAPIClient.search(forLookup: lookup) { response in
            switch response {
            case .success(let data):
                guard let data = data else { return }
                let resultsData = data["results"] as? [[String: Any]?]?
                DispatchQueue.main.async {
                    guard let resultsData = resultsData else { return }
                    completion(resultsData, nil)
                }
            case .failed(let error):
                completion(nil, error)
            }
        }
    }
    
    func searchForTracks(completion: @escaping (_ results: [CasterSearchResult]? , _ error: Error?) -> Void) {
        guard let searchTerm = searchTerm else { return }
        iTunesAPIClient.search(for: searchTerm) { response in
            switch response {
            case .success(let data):
                guard let data = data else { return }
                let resultsData = data["results"] as? [[String: Any]?]?
                if let resultsData = resultsData {
                    var results = [CasterSearchResult]()
                    resultsData?.forEach { resultingData in
                        guard let resultingData = resultingData else { return }
                        if let caster = CasterSearchResult(json: resultingData) {
                            results.append(caster)
                        }
                    }
                    DispatchQueue.main.async {
                        completion(results, nil)
                    }
                }
            case .failed(let error):
                completion(nil, error)
            }
        }
    }
}
