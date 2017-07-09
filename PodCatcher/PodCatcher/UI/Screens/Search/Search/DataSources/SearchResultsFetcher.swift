import UIKit

class SearchResultsFetcher {
    
    var searchTerm: String? = ""
    var lookup: String? = ""
    
    func setSearch(term: String?) {
        searchTerm = term
    }
    
    func setLookup(term: String?) {
        lookup = term
    }
    
    func searchForTracksFromLookup(completion: @escaping (_ results: [[String: Any]?]? , _ error: Error?) -> Void) {
        iTunesAPIClient.search(forLookup: lookup) { response in
            switch response {
            case .success(let data):
                guard let data = data else { return }
                let resultsData = data["results"] as? [[String: Any]?]?
                DispatchQueue.main.async {
                    completion(resultsData!, nil)
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
