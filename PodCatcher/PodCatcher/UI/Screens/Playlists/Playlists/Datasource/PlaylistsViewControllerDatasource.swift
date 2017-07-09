import UIKit

final class PlaylistViewControllerDataSource: NSObject {
    var playlistDataStack = PlaylistsCoreDataStack()
}

extension PlaylistViewControllerDataSource: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playlistDataStack.playlists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as PlaylistCell
        let name = playlistDataStack.playlists[indexPath.row].value(forKeyPath: "playlistName") as! String
        let date = playlistDataStack.playlists[indexPath.row].value(forKeyPath: "dateCreated") as! NSDate
        cell.titleLabel.text = name + " " + String(describing: date)
        cell.albumArtView.image = #imageLiteral(resourceName: "light-placehoder-2")
        return cell
    }
}
