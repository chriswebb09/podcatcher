//
//  Episode+CoreDataProperties.swift
//  
//
//  Created by Christopher Webb on 5/12/18.
//
//

import Foundation
import CoreData


extension Episode {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Episode> {
        return NSFetchRequest<Episode>(entityName: "Episode")
    }

    @NSManaged public var date: NSDate?
    @NSManaged public var duration: Double
    @NSManaged public var episodeDescription: String?
    @NSManaged public var episodeTitle: String?
    @NSManaged public var favorite: Bool
    @NSManaged public var mediaUrlString: String?
    @NSManaged public var podcastArtUrlString: String?
    @NSManaged public var podcastArtworkImage: NSData?
    @NSManaged public var podcastTitle: String?
    @NSManaged public var stringDuration: String?
    @NSManaged public var tags: NSObject?
    @NSManaged public var playlist: NSOrderedSet?
    @NSManaged public var podcast: Podcaster?

}

// MARK: Generated accessors for playlist
extension Episode {

    @objc(insertObject:inPlaylistAtIndex:)
    @NSManaged public func insertIntoPlaylist(_ value: Playlist, at idx: Int)

    @objc(removeObjectFromPlaylistAtIndex:)
    @NSManaged public func removeFromPlaylist(at idx: Int)

    @objc(insertPlaylist:atIndexes:)
    @NSManaged public func insertIntoPlaylist(_ values: [Playlist], at indexes: NSIndexSet)

    @objc(removePlaylistAtIndexes:)
    @NSManaged public func removeFromPlaylist(at indexes: NSIndexSet)

    @objc(replaceObjectInPlaylistAtIndex:withObject:)
    @NSManaged public func replacePlaylist(at idx: Int, with value: Playlist)

    @objc(replacePlaylistAtIndexes:withPlaylist:)
    @NSManaged public func replacePlaylist(at indexes: NSIndexSet, with values: [Playlist])

    @objc(addPlaylistObject:)
    @NSManaged public func addToPlaylist(_ value: Playlist)

    @objc(removePlaylistObject:)
    @NSManaged public func removeFromPlaylist(_ value: Playlist)

    @objc(addPlaylist:)
    @NSManaged public func addToPlaylist(_ values: NSOrderedSet)

    @objc(removePlaylist:)
    @NSManaged public func removeFromPlaylist(_ values: NSOrderedSet)

}
