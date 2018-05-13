//
//  SubscriptionReader.swift
//  PodCatcher
//
//  Created by Christopher Webb on 5/12/18.
//  Copyright © 2018 Christopher Webb-Orenstein. All rights reserved.
//

import Foundation
import CoreData
import UIKit

protocol SubscriptionReader: SubscriptionStorage {
    func fetchPodcasts(managedContext: NSManagedObjectContext) -> [Podcaster]
}

extension SubscriptionReader {
    
    func fetchPodcasts(managedContext: NSManagedObjectContext) -> [Podcaster] {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName:"Podcaster")
        do {
            let pod = try managedContext.fetch(fetchRequest) as! [Podcaster]
            return pod
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return []
        }
    }
    
}
