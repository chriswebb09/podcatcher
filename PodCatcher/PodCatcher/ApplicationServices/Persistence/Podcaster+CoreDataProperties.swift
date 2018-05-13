//
//  Podcaster+CoreDataProperties.swift
//  
//
//  Created by Christopher Webb on 5/12/18.
//
//

import Foundation
import CoreData


extension Podcaster {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Podcaster> {
        return NSFetchRequest<Podcaster>(entityName: "Podcaster")
    }

    @NSManaged public var artistId: String?
    @NSManaged public var category: String?
    @NSManaged public var feedUrl: String?
    @NSManaged public var itunesUrl: String?
    @NSManaged public var podcastArtist: String?
    @NSManaged public var podcastArtworkImage: NSData?
    @NSManaged public var podcastArtworkUrl: String?
    @NSManaged public var podcastId: String?
    @NSManaged public var podcastTitle: String?
    @NSManaged public var starred: Bool
    @NSManaged public var subscribed: Bool
    @NSManaged public var tags: NSObject?
    @NSManaged public var episodes: NSOrderedSet?

}

// MARK: Generated accessors for episodes
extension Podcaster {

    @objc(insertObject:inEpisodesAtIndex:)
    @NSManaged public func insertIntoEpisodes(_ value: Episode, at idx: Int)

    @objc(removeObjectFromEpisodesAtIndex:)
    @NSManaged public func removeFromEpisodes(at idx: Int)

    @objc(insertEpisodes:atIndexes:)
    @NSManaged public func insertIntoEpisodes(_ values: [Episode], at indexes: NSIndexSet)

    @objc(removeEpisodesAtIndexes:)
    @NSManaged public func removeFromEpisodes(at indexes: NSIndexSet)

    @objc(replaceObjectInEpisodesAtIndex:withObject:)
    @NSManaged public func replaceEpisodes(at idx: Int, with value: Episode)

    @objc(replaceEpisodesAtIndexes:withEpisodes:)
    @NSManaged public func replaceEpisodes(at indexes: NSIndexSet, with values: [Episode])

    @objc(addEpisodesObject:)
    @NSManaged public func addToEpisodes(_ value: Episode)

    @objc(removeEpisodesObject:)
    @NSManaged public func removeFromEpisodes(_ value: Episode)

    @objc(addEpisodes:)
    @NSManaged public func addToEpisodes(_ values: NSOrderedSet)

    @objc(removeEpisodes:)
    @NSManaged public func removeFromEpisodes(_ values: NSOrderedSet)

}
