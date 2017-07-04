import UIKit

class SearchControllerDataSource: NSObject {
    let store = TrackDataStore()
    var items = [PodcastSearchResult]()
    
    var searchTerm: String = ""
    
    func setSearch(term: String) {
        searchTerm = term
    }
    
    func searchForTracks(completion: @escaping (_ results: [CasterSearchResult]? , _ error: Error?) -> Void) {
        iTunesAPIClient.search(for: searchTerm) { response in
            
            switch response {
            case .success(let data):
                let resultsData = data["results"] as! [[String: Any]]
                let results = ResultsParser.parse(resultsData: resultsData)
                completion(results, nil)
            case .failed(let error):
                completion(nil, error)
            }
        }
    }
}

extension SearchControllerDataSource: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as SearchResultCell
        if items.count > 0 {
            if let title = items[indexPath.row].podcastTitle {
                cell.titleLabel.text = title
            }
        }
        cell.layoutSubviews()
        return cell
    }
}
