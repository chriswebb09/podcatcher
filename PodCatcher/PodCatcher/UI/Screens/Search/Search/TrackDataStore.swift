import UIKit

class SearchResultsFetcher {
    
    var searchTerm: String = ""
    var lookup: String = ""
    
    func setSearch(term: String) {
        searchTerm = term
    }
    
    func setLookup(term: String) {
        lookup = term
    }
    
    func searchForTracksFromLookup(completion: @escaping (_ results: [CasterSearchResult]? , _ error: Error?) -> Void) {
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
