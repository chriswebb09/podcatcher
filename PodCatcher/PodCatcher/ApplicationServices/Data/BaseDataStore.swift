import UIKit

class BaseDataStore: NSObject {
    
    var searchTerm: String = ""
    
    func setSearch(term: String) {
        searchTerm = term
    }
    
    var lookup: String = ""
    
    func searchForTracksFromLookup(completion: @escaping (_ results: [CasterSearchResult]? , _ error: Error?) -> Void) {
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
    
    static func userSignIn(username: String, password: String, completion: @escaping (PodCatcherUser?, Error?) -> Void) {
        AuthClient.loginToAccount(email: username, password: password) { user, error in
            print("here")
            if let error = error {
                print(error.localizedDescription)
                completion(nil, error)
                return
            }
            PullData.pullFromDatabase { pulled in
                dump(pulled)
                guard let user = user else { return }
                pulled.username = user.uid
                pulled.userId = user.uid
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    completion(pulled, nil)
                }
            }
        }
    }
}
