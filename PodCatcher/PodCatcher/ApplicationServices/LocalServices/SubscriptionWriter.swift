//
//  SubscriptionWriter.swift
//  PodCatcher
//
//  Created by Christopher Webb on 5/12/18.
//  Copyright © 2018 Christopher Webb-Orenstein. All rights reserved.
//

import Foundation
import CoreData
import UIKit

protocol SubscriptionWriter: SubscriptionStorage {
    func saveSubscription(manageContext: NSManagedObjectContext, item: Podcast, podcastImage: UIImage)
}

extension SubscriptionWriter {
    
    func saveSubscription(manageContext: NSManagedObjectContext, item: Podcast, podcastImage: UIImage) {
        dump(item)
        let imageData: NSData = UIImageJPEGRepresentation(podcastImage, 0)! as NSData
        let entity = NSEntityDescription.entity(forEntityName: "Podcaster", in: manageContext)!
        let podcaster = NSManagedObject(entity: entity, insertInto: manageContext)
        podcaster.setValue(item.providerId, forKey: "artistId")
        podcaster.setValue(item.podcastArtist, forKey: "podcastArtist")
        podcaster.setValue(item.podcastArtUrlString, forKey: "podcastArtworkUrl")
        podcaster.setValue(item.podcastTitle, forKey: "podcastTitle")
        podcaster.setValue(item.feedUrl, forKey: "feedUrl")
        podcaster.setValue(item.category, forKey: "category")
        podcaster.setValue(item.itunesUrlString, forKey: "itunesUrl")
        podcaster.setValue(item.artistId, forKey: "artistId")
        podcaster.setValue(item.id, forKey: "podcastId")
        podcaster.setValue(imageData, forKey: "podcastArtworkImage")
        podcaster.setValue(true, forKey: "subscribed")
        do {
            try manageContext.save()
            podcasts.append(podcaster)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
}
