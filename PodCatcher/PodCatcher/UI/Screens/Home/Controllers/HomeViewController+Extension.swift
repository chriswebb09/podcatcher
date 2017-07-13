import UIKit
import CoreData

extension HomeViewController: UICollectionViewDelegate {
    
    func logoutTapped() {
        delegate?.logout(tapped: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch mode {
        case .subscription:
            break
        case .edit:
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
            }
            let context = appDelegate.persistentContainer.viewContext
            context.delete(fetchedResultsController.object(at: indexPath))
            reloadData()
            do {
                try context.save()
            } catch let error {
                let fetchError = error as NSError
                print("Unable to Perform Fetch Request")
                print("\(fetchError), \(fetchError.localizedDescription)")
            }
            if let count = fetchedResultsController.fetchedObjects?.count {
                if count == 0 {
                    mode = .edit
                    rightButtonItem.title = "Edit"
                }
            }
        }
    }
}

extension HomeViewController: UIScrollViewDelegate {
    
    func collectionViewConfiguration() {
        collectionView.delegate = self
        collectionView.dataSource = dataSource
        collectionView.isPagingEnabled = true
        collectionView.isScrollEnabled = true
        collectionView.decelerationRate = UIScrollViewDecelerationRateFast
        collectionView.backgroundColor = .clear
    }
}

extension HomeViewController: NSFetchedResultsControllerDelegate {
    
    func reloadData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let fetchRequest:NSFetchRequest<Subscription> = Subscription.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "feedUrl", ascending: true)]
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: appDelegate.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        
        do {
            try fetchedResultsController.performFetch()
            collectionView.reloadData()
        } catch let error {
            print(error)
        }
    }
    
    func setupCoordinator() {
        persistentContainer.loadPersistentStores { (persistentStoreDescription, error) in
            if let error = error {
                print("Unable to Load Persistent Store")
                print("\(error), \(error.localizedDescription)")
            } else {
                do {
                    try self.fetchedResultsController.performFetch()
                } catch let error {
                    let fetchError = error as NSError
                    print("Unable to Perform Fetch Request")
                    print("\(fetchError), \(fetchError.localizedDescription)")
                }
            }
        }
    }
}

extension HomeViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let itemNumber = fetchedResultsController.sections?[section].numberOfObjects {
            if itemNumber > 0 {
                viewShown = .collection
            }
        }
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as SubscribedPodcastCell
        let item = fetchedResultsController.object(at: indexPath)
        if let image = UIImage(data: item.artworkImage! as Data) {
            let model = SubscribedPodcastCellViewModel(trackName: item.podcastTitle as! String, albumImageURL: image)
            DispatchQueue.main.async {
                cell.configureCell(with: model, withTime: 0)
            }
            
        }
        return cell
    }
}
