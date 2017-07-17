//
//  Subscription+CoreDataProperties.swift
//  
//
//  Created by Christopher Webb-Orenstein on 7/17/17.
//
//

import Foundation
import CoreData


extension Subscription {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Subscription> {
        return NSFetchRequest<Subscription>(entityName: "Subscription")
    }

    @NSManaged public var artworkImage: NSData?
    @NSManaged public var episodeCount: Int32
    @NSManaged public var feedUrl: String?
    @NSManaged public var id: String?
    @NSManaged public var lastUpdate: NSDate?
    @NSManaged public var podcastTitle: String?
    @NSManaged public var uid: String?
    @NSManaged public var artworkImageUrl: String?

}
