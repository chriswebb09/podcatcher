//
//  Playlist+CoreDataProperties.swift
//  
//
//  Created by Christopher Webb on 5/12/18.
//
//

import Foundation
import CoreData


extension Playlist {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Playlist> {
        return NSFetchRequest<Playlist>(entityName: "Playlist")
    }

    @NSManaged public var dateCreated: NSDate?
    @NSManaged public var episodes: NSObject?
    @NSManaged public var image: NSData?
    @NSManaged public var name: String?
    @NSManaged public var numberOfItems: Double
    @NSManaged public var playlistId: String?
    @NSManaged public var primaryCategory: String?
    @NSManaged public var tags: NSObject?
    @NSManaged public var timeListened: Double
    @NSManaged public var playlistEpisodes: NSOrderedSet?

}

// MARK: Generated accessors for playlistEpisodes
extension Playlist {

    @objc(insertObject:inPlaylistEpisodesAtIndex:)
    @NSManaged public func insertIntoPlaylistEpisodes(_ value: Episode, at idx: Int)

    @objc(removeObjectFromPlaylistEpisodesAtIndex:)
    @NSManaged public func removeFromPlaylistEpisodes(at idx: Int)

    @objc(insertPlaylistEpisodes:atIndexes:)
    @NSManaged public func insertIntoPlaylistEpisodes(_ values: [Episode], at indexes: NSIndexSet)

    @objc(removePlaylistEpisodesAtIndexes:)
    @NSManaged public func removeFromPlaylistEpisodes(at indexes: NSIndexSet)

    @objc(replaceObjectInPlaylistEpisodesAtIndex:withObject:)
    @NSManaged public func replacePlaylistEpisodes(at idx: Int, with value: Episode)

    @objc(replacePlaylistEpisodesAtIndexes:withPlaylistEpisodes:)
    @NSManaged public func replacePlaylistEpisodes(at indexes: NSIndexSet, with values: [Episode])

    @objc(addPlaylistEpisodesObject:)
    @NSManaged public func addToPlaylistEpisodes(_ value: Episode)

    @objc(removePlaylistEpisodesObject:)
    @NSManaged public func removeFromPlaylistEpisodes(_ value: Episode)

    @objc(addPlaylistEpisodes:)
    @NSManaged public func addToPlaylistEpisodes(_ values: NSOrderedSet)

    @objc(removePlaylistEpisodes:)
    @NSManaged public func removeFromPlaylistEpisodes(_ values: NSOrderedSet)

}
