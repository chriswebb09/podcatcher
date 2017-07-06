import UIKit
import CoreData

class PlaylistsDataStore {
    
    var playlists: [NSManagedObject] = []
    
    
    func save(name: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "TestPlaylist", in: managedContext)!
        let playlist = NSManagedObject(entity: entity, insertInto: managedContext)
        playlist.setValue(name, forKeyPath: "title")
        do {
            try managedContext.save()
            playlists.append(playlist)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func fetchFromCore() {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        let managedContext =
            appDelegate.persistentContainer.viewContext
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "TestPlaylist")
        do {
            playlists = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
}

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
                let results = SearchResultsFetcher.parse(resultsData: resultsData)
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
                let results = SearchResultsFetcher.parse(resultsData: resultsData)
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
