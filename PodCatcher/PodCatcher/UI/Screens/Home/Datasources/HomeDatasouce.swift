//
//  HomeDatasouce.swift
//  PodCatcher
//
//  Created by Christopher Webb on 5/12/18.
//  Copyright © 2018 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit
import CoreData

class HomeDatasouce: NSObject {
    
    var mode: HomeInteractionMode = .subscription
    
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Podcaster")
    
    var managedContext: NSManagedObjectContext!
    
    var fetchedResultsController:NSFetchedResultsController<Podcaster>!
    
    var itemCount: Int {
        return fetchedResultsController.sections?[0].numberOfObjects ?? 0
    }
    
    func reloadData() {
        do {
            try fetchedResultsController.performFetch()
        } catch let error {
            print(error.localizedDescription)
        }
    }
}

extension HomeDatasouce: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[0].numberOfObjects ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let object = fetchedResultsController.object(at: indexPath)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SubscriptionCell.reuseIdentifier, for: indexPath) as! SubscriptionCell
        if let imageData = object.podcastArtworkImage, let image = UIImage(data: imageData as Data) {
            let cellModel = SubsciptionCellViewModel(trackName: object.podcastTitle!, albumImageURL: image)
            switch mode {
            case .edit:
                cell.configureCell(with: cellModel, withTime: 0, mode: .edit)
            case .subscription:
                cell.configureCell(with: cellModel, withTime: 0, mode: .done)
            }
        }
        return cell
    }
}
