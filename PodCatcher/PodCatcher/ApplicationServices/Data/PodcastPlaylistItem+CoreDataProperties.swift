//
//  PodcastPlaylistItem+CoreDataProperties.swift
//  
//
//  Created by Christopher Webb-Orenstein on 7/6/17.
//
//

import Foundation
import CoreData


extension PodcastPlaylistItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PodcastPlaylistItem> {
        return NSFetchRequest<PodcastPlaylistItem>(entityName: "PodcastPlaylistItem")
    }

    @NSManaged public var artistId: String?
    @NSManaged public var artwork: NSData?
    @NSManaged public var artworkUrl: String?
    @NSManaged public var audioUrl: String?
    @NSManaged public var playlistId: String?
    @NSManaged public var episodeTitle: String?
    @NSManaged public var date: NSDate?
    @NSManaged public var stringDate: String?
    @NSManaged public var episodeDescription: String?
    @NSManaged public var duration: Double
    @NSManaged public var playlist: PodcastPlaylist?

}
