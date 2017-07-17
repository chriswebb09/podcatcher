import UIKit
import CoreData

extension PlaylistsViewController: ReloadableTable, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = fetchedResultsController.sections?[section].numberOfObjects {
            if count <= 0 {
                tableView.backgroundView?.addSubview(emptyView)
                navigationItem.leftBarButtonItem = nil
            } else {
                emptyView?.removeFromSuperview()
                navigationItem.setLeftBarButton(leftButtonItem, animated: false)
            }
        }
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as PlaylistCell
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(swipeFunc))
        swipeRight.direction = .left
        if let art = fetchedResultsController.object(at: indexPath).artwork {
            let image = UIImage(data: art as Data)
            cell.albumArtView.image = image
        } else {
            cell.albumArtView.image = #imageLiteral(resourceName: "light-placehoder-2")
        }
        let text = fetchedResultsController.object(at: indexPath).playlistName
        cell.titleLabel.text = text?.uppercased()
        cell.numberOfItemsLabel.text = "Podcasts"
        cell.addGestureRecognizer(swipeRight)
        return cell
    }
}

extension PlaylistsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.height / 6
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch mode {
        case .edit:
            let id = fetchedResultsController.object(at: indexPath).playlistId
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            let context = appDelegate.persistentContainer.viewContext
            context.delete(fetchedResultsController.object(at: indexPath))
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PodcastPlaylistItem")
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            fetchRequest.predicate = NSPredicate(format: "playlistId == %@", id!)
            do {
                try appDelegate.persistentContainer.viewContext.execute(deleteRequest)
            } catch let error as NSError {
                print(error.localizedDescription)
            }
            self.reloadData()
            do {
                try context.save()
            } catch let error {
                print("Unable to Perform Fetch Request \(error), \(error.localizedDescription)")
            }
            if let count = fetchedResultsController.fetchedObjects?.count {
                if count == 0 {
                    mode = .add
                    rightButtonItem.title = "Edit"
                }
            }
        case .add:
            guard let text = fetchedResultsController.object(at: indexPath).playlistId else { return }
            switch reference {
            case .addPodcast:
                reference = .checkList
                DispatchQueue.main.async {
                    self.reloadData()
                }
                delegate?.didAssignPlaylist(with: text)
            case .checkList:
                guard let title = fetchedResultsController.object(at: indexPath).playlistName else { return }
                let playlist = PlaylistViewController(index: 0)
                playlist.playlistId = text
                playlist.playlistTitle = title
                navigationController?.pushViewController(playlist, animated: false)
            }
        }
    }
}

extension PlaylistsViewController: EntryPopoverDelegate {
    
    func userDidEnterPlaylistName(name: String) {
        playlistDataStack.save(name: name, uid: userID)
        reloadData()
    }
    
    func addPlaylist() {
        UIView.animate(withDuration: 0.05) { [weak self] in
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
