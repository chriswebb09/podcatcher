import UIKit

extension PlaylistsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.height / 4
    }
}

extension PlaylistsViewController: EntryPopoverDelegate {
    
    func userDidEnterPlaylistName(name: String) {
        playlistDataStore.save(name: name)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func addPlaylist() {
        UIView.animate(withDuration: 0.15) { [weak self] in
            guard let strongSelf = self else {
                return
            }
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
