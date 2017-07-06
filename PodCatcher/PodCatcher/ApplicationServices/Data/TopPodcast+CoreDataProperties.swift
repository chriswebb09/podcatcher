//
//  TopPodcast+CoreDataProperties.swift
//  
//
//  Created by Christopher Webb-Orenstein on 7/5/17.
//
//

import Foundation
import CoreData


extension TopPodcast {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TopPodcast> {
        return NSFetchRequest<TopPodcast>(entityName: "TopPodcast")
    }

    @NSManaged public var podcastTitle: String?
    @NSManaged public var podcastFeedUrlString: String?
    @NSManaged public var podcastArtist: String?
    @NSManaged public var podcastArt: NSData?
    @NSManaged public var numberOfEpisodes: Float
    @NSManaged public var ituneUrl: String?
    @NSManaged public var itunesId: String?

}
