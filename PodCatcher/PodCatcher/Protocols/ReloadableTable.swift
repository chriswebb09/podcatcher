import CoreData
import UIKit

protocol ReloadableTable: class {
    
    var fetchedResultsController:NSFetchedResultsController<PodcastPlaylist>! { get set }
    var tableView: UITableView { get set }
    func reloadData()
    var userID: String! { get set }
}

extension ReloadableTable {
    func reloadData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let fetchRequest:NSFetchRequest<PodcastPlaylist> = PodcastPlaylist.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "playlistId", ascending: true)]
        fetchRequest.predicate = NSPredicate(format: "uid == %@", userID)
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: appDelegate.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        do {
            try fetchedResultsController.performFetch()
            tableView.reloadData()
        } catch let error {
            print(error)
        }
    }
}
