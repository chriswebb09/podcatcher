//
//  Podcast+CoreDataProperties.swift
//  
//
//  Created by Christopher Webb-Orenstein on 1/15/18.
//
//

import Foundation
import CoreData


extension Podcast {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Podcast> {
        return NSFetchRequest<Podcast>(entityName: "Podcast")
    }

    @NSManaged public var episodeTitle: String?
    @NSManaged public var audioUrl: String?
    @NSManaged public var podcasterName: String?
    @NSManaged public var podcasterId: String?
    @NSManaged public var episodeId: String?
    @NSManaged public var podcastImage: NSData?

}
