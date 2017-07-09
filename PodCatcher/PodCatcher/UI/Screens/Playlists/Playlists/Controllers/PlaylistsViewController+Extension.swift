import UIKit
import CoreData

extension PlaylistsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.height / 6
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let text = fetchedResultsController.object(at: indexPath).playlistId else { return }
        switch reference {
        case .addPodcast:
            reference = .checkList
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.reloadData()
            }
            
            delegate?.didAssignPlaylist(with: text)
            //self.tabBarController?.selectedIndex = 2
        case .checkList:
            let playlist = PlaylistViewController(index: 0)
            playlist.playlistId = text
            navigationController?.pushViewController(playlist, animated: false)
        }
    }
}

extension PlaylistsViewController: EntryPopoverDelegate {
    
    func userDidEnterPlaylistName(name: String) {
        playlistDataStack.save(name: name)
        reloadData()
    }
    
    func addPlaylist() {
        UIView.animate(withDuration: 0.15) { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.entryPop.showPopView(viewController: strongSelf)
            strongSelf.entryPop.popView.isHidden = false
        }
        entryPop.popView.doneButton.addTarget(self, action: #selector(hidePop), for: .touchUpInside)
    }
    
    func hidePop() {
        entryPop.hidePopView(viewController: self)
        tableView.reloadData()
    }
}
