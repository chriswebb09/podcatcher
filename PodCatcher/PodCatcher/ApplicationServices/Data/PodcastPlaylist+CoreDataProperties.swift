//
//  PodcastPlaylist+CoreDataProperties.swift
//  
//
//  Created by Christopher Webb-Orenstein on 7/9/17.
//
//

import Foundation
import CoreData


extension PodcastPlaylist {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PodcastPlaylist> {
        return NSFetchRequest<PodcastPlaylist>(entityName: "PodcastPlaylist")
    }

    @NSManaged public var artwork: NSData?
    @NSManaged public var dateCreated: NSDate?
    @NSManaged public var numberOfItems: Int32
    @NSManaged public var numberOfPlays: Int32
    @NSManaged public var playlistId: String?
    @NSManaged public var playlistName: String?
    @NSManaged public var timeSpentListening: Double

}
