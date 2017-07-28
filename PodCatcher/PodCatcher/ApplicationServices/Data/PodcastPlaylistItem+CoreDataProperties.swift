import UIKit
import CoreData

extension PodcastPlaylistItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PodcastPlaylistItem> {
        return NSFetchRequest<PodcastPlaylistItem>(entityName: "PodcastPlaylistItem")
    }

    @NSManaged public var artistId: String?
    @NSManaged public var artwork: NSData?
    @NSManaged public var artworkUrl: String?
    @NSManaged public var audioUrl: String?
    @NSManaged public var date: NSDate?
    @NSManaged public var duration: Double
    @NSManaged public var episodeDescription: String?
    @NSManaged public var episodeTitle: String?
    @NSManaged public var playlistId: String?
    @NSManaged public var stringDate: String?
    @NSManaged public var artistName: String?
    @NSManaged public var artistFeedUrl: String?

}


extension PodcastPlaylistItem {
    static func addItem(item: CasterSearchResult, for index: Int) -> PodcastPlaylistItem? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        let managedContext = appDelegate.coreData.managedContext
        let newItem = PodcastPlaylistItem(context: managedContext)
        newItem.audioUrl = item.episodes[index].audioUrlString
        newItem.artworkUrl = item.podcastArtUrlString
        newItem.artistId = item.id
        newItem.episodeTitle = item.episodes[index].title
        newItem.episodeDescription = item.episodes[index].description
        newItem.stringDate = item.episodes[index].date
        return newItem
    }
}
