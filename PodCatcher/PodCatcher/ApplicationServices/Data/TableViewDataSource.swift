import CoreData
import UIKit

class TableViewDataSource<Delegate: TableViewDataSourceDelegate>: NSObject, UITableViewDataSource, NSFetchedResultsControllerDelegate {
    
    typealias Object = Delegate.Object
    typealias Cell = Delegate.Cell
    
    // MARK: Private
    
    fileprivate let tableView: UITableView
    fileprivate let fetchedResultsController: NSFetchedResultsController<Object>
    fileprivate weak var delegate: Delegate!
    fileprivate let cellIdentifier: String
    var emptyView = InformationView(data: "Subscribe To Your Favorite Podcasts!", icon: #imageLiteral(resourceName: "mic-icon").withRenderingMode(.alwaysTemplate))
    fileprivate let backgroundView = UIView()
    
    required init(tableView: UITableView, identifier: String, fetchedResultsController: NSFetchedResultsController<Object>, delegate: Delegate) {
        self.tableView = tableView
        cellIdentifier = identifier
        self.fetchedResultsController = fetchedResultsController
        self.delegate = delegate
        
        super.init()
        
        fetchedResultsController.delegate = self
        try! fetchedResultsController.performFetch()
        tableView.dataSource = self
        tableView.reloadData()
    }
    
    var itemCount: Int {
        return fetchedResultsController.sections?[0].numberOfObjects ?? 0
    }
    
    
    var selectedObject: Object? {
        guard let indexPath = tableView.indexPathForSelectedRow else { return nil }
        return objectAtIndexPath(indexPath)
    }
    
    func objectAtIndexPath(_ indexPath: IndexPath) -> Object {
        return fetchedResultsController.object(at: indexPath)
    }
    
    func reconfigureFetchRequest(_ configure: (NSFetchRequest<Object>) -> ()) {
        NSFetchedResultsController<NSFetchRequestResult>.deleteCache(withName: fetchedResultsController.cacheName)
        configure(fetchedResultsController.fetchRequest)
        do { try fetchedResultsController.performFetch() } catch { fatalError("fetch request failed") }
        DispatchQueue.main.async {
            self.tableView.reloadData()
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = fetchedResultsController.sections?[section] else { return 0 }
        let itemCount = section.numberOfObjects
        if itemCount > 0 {
            tableView.backgroundView = backgroundView
        } else {
            tableView.backgroundView = emptyView
        }
        return section.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let object = fetchedResultsController.object(at: indexPath)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? Cell else { fatalError("Unexpected cell type at \(indexPath)") }
        DispatchQueue.main.async {
            self.delegate.configure(cell, for: object)
        }
        return cell
    }
    
    // MARK: NSFetchedResultsControllerDelegate
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            guard let indexPath = newIndexPath else { return }
            tableView.insertRows(at: [indexPath], with: .fade)
        case .update:
            guard let indexPath = indexPath else { return }
            let object = objectAtIndexPath(indexPath)
            guard let cell = tableView.cellForRow(at: indexPath) as? Cell else { break }
            delegate.configure(cell, for: object)
        case .move:
            guard let indexPath = indexPath else { return }
            guard let newIndexPath = newIndexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.insertRows(at: [newIndexPath], with: .fade)
        case .delete:
            guard let indexPath = indexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func setIcon(icon: UIImage) {
        emptyView.setIcon(icon: icon)
    }
    
    func setText(text: String) {
        emptyView.setLabel(text: text)
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}
