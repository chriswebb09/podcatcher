//
//  TopPodcast+CoreDataProperties.swift
//  
//
//  Created by Christopher Webb-Orenstein on 1/11/18.
//
//

import Foundation
import CoreData


extension TopPodcast {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TopPodcast> {
        return NSFetchRequest<TopPodcast>(entityName: "TopPodcast")
    }

    @NSManaged public var itunesId: String?
    @NSManaged public var itunesUrl: String?
    @NSManaged public var numberOfEpisodes: Int32
    @NSManaged public var podcastArt: NSData?
    @NSManaged public var podcastArtist: String?
    @NSManaged public var podcastArtUrl: String?
    @NSManaged public var podcastFeedUrlString: String?
    @NSManaged public var podcastTitle: String?
    @NSManaged public var tags: [NSString]?

}
