import UIKit

class PlaylistViewControllerDataSource: NSObject {
    var playlistDataStore = PlaylistsDataStore()
}

extension PlaylistViewControllerDataSource: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(playlistDataStore.playlists.count)
        return playlistDataStore.playlists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as PlaylistCell
        cell.titleLabel.text = playlistDataStore.playlists[indexPath.row].value(forKeyPath: "title") as? String
        return cell
    }
}
