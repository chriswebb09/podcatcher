import UIKit

class HomeCollectionDataSource: BaseMediaControllerDataSource {
    
    let store = SearchResultsDataStore()
    
    var lookup: String = ""
    
    var response = [TopItem]() {
        didSet {
            for item in response {
                lookup = item.id
                if !categories.contains(item.category) {
                    categories.append(item.category)
                }
                self.searchForTracks { result in
                    guard let result = result.0 else { return }
                    self.items.append(contentsOf: result)
                }
            }
        }
    }
    
    var items = [CasterSearchResult]() {
        didSet {
            
        }
    }
    
    var categories: [String] = []
    
    var viewShown: ShowView {
        guard let casters = casters else { return .empty }
        if casters.count > 0 {
            return .collection
        } else {
            return .empty
        }
    }
    
    func searchForTracks(completion: @escaping (_ results: [CasterSearchResult]? , _ error: Error?) -> Void) {
        iTunesAPIClient.search(forLookup: lookup) { response in
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
