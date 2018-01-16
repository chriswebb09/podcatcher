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
    @NSManaged public var uid: String?
    @NSManaged public var podcast: NSSet?
    @NSManaged var tags: [String]
    
}

// MARK: Generated accessors for podcast
extension PodcastPlaylist {
    
    @objc(addPodcastObject:)
    @NSManaged public func addToPodcast(_ value: PodcastPlaylistItem)
    
    @objc(removePodcastObject:)
    @NSManaged public func removeFromPodcast(_ value: PodcastPlaylistItem)
    
    @objc(addPodcast:)
    @NSManaged public func addToPodcast(_ values: NSSet)
    
    @objc(removePodcast:)
    @NSManaged public func removeFromPodcast(_ values: NSSet)
}
