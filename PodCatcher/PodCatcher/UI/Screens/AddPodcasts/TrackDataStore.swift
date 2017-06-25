import UIKit

class TrackDataStore {
    var searchTerm: String = ""
    
    func setSearch(term: String) {
        searchTerm = term
    }
    
    func searchForTracks(completion: @escaping (_ playlist: Playlist? , _ error: Error?) -> Void) {
        iTunesAPIClient.search(for: searchTerm) { response in
            switch response {
            case .success(let data):
                let tracksData = data["results"] as! [[String: Any]]
                let playlist: Playlist? = Playlist()
                tracksData.forEach { data in
                    let newItem: PlaylistItem? = PlaylistItem()
                    playlist?.append(newPlaylistItem: newItem)
                }
                completion(playlist, nil)
            case .failed(let error):
                completion(nil, error)
            }
        }
    }
    
}
