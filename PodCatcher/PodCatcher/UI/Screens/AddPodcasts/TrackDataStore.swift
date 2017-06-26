import UIKit

class TrackDataStore {
    var searchTerm: String = ""
    
    func setSearch(term: String) {
        searchTerm = term
    }
    
    func searchForTracks(completion: @escaping (_ results: [PodcastSearchResult]? , _ error: Error?) -> Void) {
        var newResults = [PodcastSearchResult]()
        iTunesAPIClient.search(for: searchTerm) { response in
            switch response {
            case .success(let data):
                let resultsData = data["results"] as! [[String: Any]]
                
                resultsData.forEach { results in
                    var newResult = PodcastSearchResult()
                    let artUrl = results["artworkUrl600"] as? String
                    newResult.podcastArtUrlString = artUrl
                    newResults.append(newResult)
                }
                
                completion(newResults, nil)

            case .failed(let error):
                completion(nil, error)
            }
        }
    }
}
