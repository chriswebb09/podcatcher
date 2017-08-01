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
