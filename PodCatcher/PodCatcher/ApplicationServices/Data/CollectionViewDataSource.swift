import CoreData
import UIKit

enum ContentState {
    case empty, collection
}

class CollectionViewDataSource<Delegate: CollectionViewDataSourceDelegate>: NSObject, UICollectionViewDataSource, NSFetchedResultsControllerDelegate {
    
    typealias Object = Delegate.Object
    typealias Cell = Delegate.Cell
    
    // MARK: Private
    
    fileprivate let emptyView = EmptyView()
    fileprivate let collectionView: UICollectionView
    fileprivate let fetchedResultsController: NSFetchedResultsController<Object>
    fileprivate weak var delegate: Delegate!
    fileprivate let cellIdentifier: String
    fileprivate let backgroundView = UIView()
    var contentState: ContentState = .empty
    var itemCount: Int = 0
    
    required init(collectionView: UICollectionView, identifier: String, fetchedResultsController: NSFetchedResultsController<Object>, delegate: Delegate) {
        self.collectionView = collectionView
        self.cellIdentifier = identifier
        self.fetchedResultsController = fetchedResultsController
        self.delegate = delegate
        super.init()
        fetchedResultsController.delegate = self
        try! fetchedResultsController.performFetch()
        collectionView.dataSource = self
        collectionView.reloadData()
        emptyView.frame = UIScreen.main.bounds
        backgroundView.frame = UIScreen.main.bounds
        collectionView.backgroundView = emptyView
        backgroundView.backgroundColor = .lightGray
        
    }
    
    var selectedObject: Object? {
        guard let indexPath = collectionView.indexPathsForSelectedItems?[0] else { return nil }
        return objectAtIndexPath(indexPath)
    }
    
    func objectAtIndexPath(_ indexPath: IndexPath) -> Object {
        return fetchedResultsController.object(at: indexPath)
    }
    
    func reconfigureFetchRequest(_ configure: (NSFetchRequest<Object>) -> ()) {
        NSFetchedResultsController<NSFetchRequestResult>.deleteCache(withName: fetchedResultsController.cacheName)
        configure(fetchedResultsController.fetchRequest)
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("fetch request failed")
        }
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    func reloadData() {
        do {
            try fetchedResultsController.performFetch()
        } catch let error {
            print(error)
        }
    }
    
    // MARK: UITableViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let section = fetchedResultsController.sections?[section] else { contentState = .empty; return 0 }
        itemCount = section.numberOfObjects
        if itemCount > 0 {
            collectionView.backgroundView = backgroundView
        } else {
            collectionView.backgroundView = emptyView
        }
        return section.numberOfObjects
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let object = fetchedResultsController.object(at: indexPath)
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? Cell else { fatalError("Unexpected cell type at \(indexPath)") }
        DispatchQueue.main.async {
            self.delegate.configure(cell, for: object)
        }
        return cell
    }
    
    // MARK: NSFetchedResultsControllerDelegate
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            guard let indexPath = newIndexPath else { return }
            collectionView.performBatchUpdates({
                collectionView.insertItems(at: [indexPath])
            }, completion: nil)
        case .update:
            guard let indexPath = indexPath else { return }
            let object = objectAtIndexPath(indexPath)
            guard let cell = collectionView.cellForItem(at: indexPath) as? Cell else { break }
            delegate.configure(cell, for: object)
        case .move:
            guard let indexPath = indexPath else { return }
            guard let newIndexPath = newIndexPath else { return }
            collectionView.performBatchUpdates({
                collectionView.deleteItems(at: [indexPath])
                collectionView.insertItems(at: [newIndexPath])
            })
        case .delete:
            guard let indexPath = indexPath else { return }
            collectionView.performBatchUpdates({
                collectionView.deleteItems(at: [indexPath])
            })
        }
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}
