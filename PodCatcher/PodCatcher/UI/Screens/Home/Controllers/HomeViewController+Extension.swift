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
            //   let item = fetchedResultsController.object(at: indexPath)
            
            guard let imageData = item.artworkImage, let image = UIImage(data: imageData as Data) else { return }
            delegate?.didSelect(at: indexPath.row, with: item, image: image)
        //.didSelect(at: indexPath.row, with: item)
        case .edit:
            let actionSheetController: UIAlertController = UIAlertController(title: "Are you sure?", message: "Pressing okay will remove this podcast from your subscription list.", preferredStyle: .alert)
            let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action in
                return
            }
            let okayAction: UIAlertAction =  UIAlertAction(title: "Okay", style: .destructive) { action in
                guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
                let context = appDelegate.persistentContainer.viewContext
                let feed = self.fetchedResultsController.object(at: indexPath).feedUrl
                context.delete(self.fetchedResultsController.object(at: indexPath))
                var subscriptions = UserDefaults.loadSubscriptions()
                if let index = subscriptions.index(of: feed!) {
                    subscriptions.remove(at: index)
                    UserDefaults.saveSubscriptions(subscriptions: subscriptions)
                }
                self.reloadData()
                do {
                    try context.save()
                } catch let error {
                    print("Unable to Perform Fetch Request \(error), \(error.localizedDescription)")
                }
            }
            
            actionSheetController.addAction(cancelAction)
            actionSheetController.addAction(okayAction)
            self.present(actionSheetController, animated: true, completion: nil)
            
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
        if let uid = self.userID {
            fetchRequest.predicate = NSPredicate(format: "uid==%@", uid)
        } else {
            fetchRequest.predicate = NSPredicate(format: "uid==%@", "none")
        }
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: appDelegate.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        do {
            try fetchedResultsController.performFetch()
            collectionView.reloadData()
        } catch let error {
            print(error)
        }
    }
    
    func setupCoordinator() {
        persistentContainer.loadPersistentStores { [weak self] persistentStoreDescription, error in
            if let strongSelf = self {
                if let error = error {
                    print("Unable to Perform Fetch Request \(error), \(error.localizedDescription)")
                } else {
                    do {
                        try strongSelf.fetchedResultsController.performFetch()
                    } catch let error {
                        print("Unable to Perform Fetch Request \(error), \(error.localizedDescription)")
                    }
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
                mode = .subscription
                rightButtonItem.title = "Edit"
                navigationItem.rightBarButtonItem = nil
            }
        }
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as SubscribedPodcastCell
        let item = fetchedResultsController.object(at: indexPath)
        
        if let imageData = item.artworkImage, let image = UIImage(data: imageData as Data), let title = item.podcastTitle {
            let model = SubscribedPodcastCellViewModel(trackName: title, albumImageURL: image)
            DispatchQueue.main.async { [weak self] in
                if let strongSelf = self {
                    switch strongSelf.mode {
                    case .edit:
                        cell.configureCell(with: model, withTime: 0, mode: .edit)
                        cell.bringSubview(toFront: cell.overlayView)
                    case  .subscription:
                        cell.configureCell(with: model, withTime: 0, mode: .done)
                    }
                }
            }
        }
        return cell
    }
}
