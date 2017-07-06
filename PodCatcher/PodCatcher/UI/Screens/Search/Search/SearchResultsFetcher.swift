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
                let results = SearchResultsFetcher.parse(resultsData: resultsData)
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
                let results = SearchResultsFetcher.parse(resultsData: resultsData)
                completion(results, nil)
            case .failed(let error):
                completion(nil, error)
            }
        }
    }
    
    @discardableResult
    static func format(data: [[String]]) -> [String: CasterSearchResult] {
        var searchResults = [String: CasterSearchResult]()
        data.forEach { array in
            guard let id = array.last else { return }
            let episode = Episodes(title: array[2], date: array[4], description: "test", duration: 29134, audioUrlString: nil, stringDuration: nil)
            if searchResults[id] != nil {
                searchResults[id]?.episodes.append(episode)
            } else {
                searchResults[id] = CasterSearchResult()
                searchResults[id]?.id = id
                searchResults[id]?.podcastArtist = array[1]
                searchResults[id]?.podcastArtUrlString = array[0]
                searchResults[id]?.podcastTitle = array[3]
                searchResults[id]?.episodes.append(episode)
                searchResults[id]?.feedUrl = array[5]
            }
        }
        return searchResults
    }
    
    @discardableResult
    static func parse(resultsData: [[String: Any]]) -> [CasterSearchResult] {
        var data = [[String]]()
        
        resultsData.forEach { resultingData in
            guard let artUrl = resultingData["artworkUrl600"] as? String else { return }
            guard let artistName = resultingData["artistName"] as? String else { return }
            guard let trackName = resultingData["trackName"] as? String else { return }
            guard let title = resultingData["collectionName"] as? String else { return }
            guard let releaseDate = resultingData["releaseDate"] as? String else { return }
            guard let id = resultingData["collectionId"] as? Int else { return }
            guard let feedUrl = resultingData["feedUrl"] as? String else { return }
            data.append([artUrl, artistName, trackName, title, releaseDate, feedUrl, String(describing: id)])
        }
        var results = [CasterSearchResult]()
        format(data: data).map { results.append($0.value) }
        return results
    }

}
