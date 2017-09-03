import CoreData
import UIKit


class CollectionViewDataSource<Delegate: CollectionViewDataSourceDelegate>: NSObject, UICollectionViewDataSource, NSFetchedResultsControllerDelegate {
    
    typealias Object = Delegate.Object
    typealias Cell = Delegate.Cell
    
    // MARK: Private
    
    var emptyView = InformationView(data: "Subscribe To Your Favorite Podcasts!", icon: #imageLiteral(resourceName: "mic-icon").withRenderingMode(.alwaysTemplate))
    
    var backgroundView = UIView()
    
    fileprivate let collectionView: UICollectionView
    let fetchedResultsController: NSFetchedResultsController<Object>
    fileprivate weak var delegate: Delegate!
    fileprivate let cellIdentifier: String
    
    var itemCount: Int {
        return fetchedResultsController.sections?[0].numberOfObjects ?? 0
    }
    
    required init(collectionView: UICollectionView, identifier: String, fetchedResultsController: NSFetchedResultsController<Object>, delegate: Delegate) {
        self.collectionView = collectionView
        self.cellIdentifier = identifier
        self.fetchedResultsController = fetchedResultsController
        self.delegate = delegate
        super.init()
        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
        } catch let error {
            print(error.localizedDescription)
        }
        collectionView.dataSource = self
        collectionView.reloadData()
        emptyView.frame = UIScreen.main.bounds
        backgroundView.frame = UIScreen.main.bounds
        collectionView.backgroundView = emptyView
        backgroundView.backgroundColor = .white
    }
    
    func reloadData() {
        do {
            try fetchedResultsController.performFetch()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    // MARK: UITableViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let section = fetchedResultsController.sections?[section] else { return 0 }
        if itemCount > 0 {
            collectionView.backgroundView = backgroundView
            collectionView.backgroundView?.layoutSubviews()
        } else {
            emptyView = InformationView(data: "Subscribe to your favorite podcasts!", icon:  #imageLiteral(resourceName: "mic-icon"))
            emptyView.setLabel(text: "Subscribe to your favorite podcasts!")
            emptyView.setIcon(icon: #imageLiteral(resourceName: "mic-icon"))
            emptyView.frame = collectionView.frame
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
                self.collectionView.insertItems(at: [indexPath])
            })
        case .update:
            guard let indexPath = indexPath else { return }
            let object = fetchedResultsController.object(at: indexPath)
            guard let cell = collectionView.cellForItem(at: indexPath) as? Cell else { break }
            delegate.configure(cell, for: object)
        case .move:
            guard let indexPath = indexPath else { return }
            guard let newIndexPath = newIndexPath else { return }
            collectionView.performBatchUpdates({
                self.collectionView.deleteItems(at: [indexPath])
                self.collectionView.insertItems(at: [newIndexPath])
            })
        case .delete:
            guard let indexPath = indexPath else { return }
            collectionView.performBatchUpdates({
                self.collectionView.deleteItems(at: [indexPath])
            })
        }
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}
