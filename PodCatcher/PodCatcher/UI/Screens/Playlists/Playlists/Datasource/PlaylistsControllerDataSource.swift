import UIKit
import CoreData

class PlaylistsControllerDataSource: NSObject {
    var fetchedResultsController: NSFetchedResultsController<PodcastPlaylist>!
    var userID: String!
    let mode: PlaylistsInteractionMode = .add
    
    init(userID: String, fetchController:  NSFetchedResultsController<PodcastPlaylist>) {
        self.fetchedResultsController = fetchController
        self.userID = userID
    }
}

extension PlaylistsControllerDataSource: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dump(fetchedResultsController.sections?[section].numberOfObjects)
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as PlaylistCell
        switch mode {
        case .add:
            cell.mode = .select
        case .edit:
            cell.mode = .delete
        }
        if let art = fetchedResultsController.object(at: indexPath).artwork {
            let image = UIImage(data: art as Data)
            cell.albumArtView.image = image
        } else {
            cell.albumArtView.image = #imageLiteral(resourceName: "light-placehoder-2")
        }
        let text = fetchedResultsController.object(at: indexPath).playlistName
        cell.titleLabel.text = text?.uppercased()
        cell.numberOfItemsLabel.text = "Podcasts"
        return cell
        
    }
    
    func setFetch() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let fetchRequest:NSFetchRequest<PodcastPlaylist> = PodcastPlaylist.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "playlistId", ascending: true)]
        fetchRequest.predicate = NSPredicate(format: "uid == %@", userID)
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: appDelegate.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
    }
}
