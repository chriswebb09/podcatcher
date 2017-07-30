import UIKit
import CoreData

extension NSManagedObject {
    
    class var entityName : String {
        let components = NSStringFromClass(self).components(separatedBy: ".")
        return components[1]
    }
}

extension NSManagedObjectContext {
    
    func insert<T : NSManagedObject>(entity: T.Type) -> T {
        let entityName = entity.entityName
        return NSEntityDescription.insertNewObject(forEntityName: entityName, into: self) as! T
    }
}

protocol Reusable { }

extension Reusable where Self: UICollectionViewCell  {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

extension Reusable where Self: UITableViewCell {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

protocol ReloadableCollection: class {
    var playlistId: String { get set }
    var fetchedResultsController: NSFetchedResultsController<PodcastPlaylistItem>! { get set }
    var collectionView: UICollectionView { get set }
    func reloadData()
}

extension ReloadableCollection {
    
    func reloadData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let fetchRequest:NSFetchRequest<PodcastPlaylistItem> = PodcastPlaylistItem.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "playlistId", ascending: true)]
        fetchRequest.predicate = NSPredicate(format: "playlistId == %@", playlistId)
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: appDelegate.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        
        do {
            try fetchedResultsController.performFetch()
            collectionView.reloadData()
        } catch let error {
            print(error)
        }
    }
}
