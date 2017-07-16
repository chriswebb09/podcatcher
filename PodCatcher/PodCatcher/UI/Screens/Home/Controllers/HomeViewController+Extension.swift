import UIKit
import CoreData

extension HomeViewController: UICollectionViewDelegate {
    
    func logoutTapped() {
        delegate?.logout(tapped: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch mode {
        case .subscription:
            let item = fetchedResultsController.object(at: indexPath)
            var caster = CasterSearchResult()
            caster.feedUrl = item.feedUrl
            delegate?.didSelect(at: indexPath.row, with: item)
        case .edit:
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            let context = appDelegate.persistentContainer.viewContext
            let feed = fetchedResultsController.object(at: indexPath).feedUrl
            context.delete(fetchedResultsController.object(at: indexPath))
            var subscriptions = UserDefaults.loadSubscriptions()
            if let index = subscriptions.index(of: feed!) {
                subscriptions.remove(at: index)
                UserDefaults.saveSubscriptions(subscriptions: subscriptions)
            }
            reloadData()
            do {
                try context.save()
            } catch let error {
                print("Unable to Perform Fetch Request \(error), \(error.localizedDescription)")
            }
            if let count = fetchedResultsController.fetchedObjects?.count {
                if count == 0 {
                    mode = .subscription
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
        persistentContainer.loadPersistentStores { persistentStoreDescription, error in
            if let error = error {
                print("Unable to Perform Fetch Request \(error), \(error.localizedDescription)")
            } else {
                do {
                    try self.fetchedResultsController.performFetch()
                } catch let error {
                    print("Unable to Perform Fetch Request \(error), \(error.localizedDescription)")
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
                navigationItem.setRightBarButton(rightButtonItem, animated: false)
            } else if itemNumber == 0 {
                viewShown = .empty
                self.navigationItem.rightBarButtonItem = nil
            }
        }
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as SubscribedPodcastCell
        let item = fetchedResultsController.object(at: indexPath)
        
        if let imageData = item.artworkImage, let image = UIImage(data: imageData as Data) {
            let model = SubscribedPodcastCellViewModel(trackName: item.podcastTitle as! String, albumImageURL: image)
            DispatchQueue.main.async {
                switch self.mode {
                case .edit:
                    cell.configureCell(with: model, withTime: 0, mode: .edit)
                     cell.bringSubview(toFront: cell.overlayView)
                //cell.cellState =
                case  .subscription:
                    //cell.cellState = .done
                    cell.configureCell(with: model, withTime: 0, mode: .done)
                   
                }
            }
        }
        return cell
    }
}
