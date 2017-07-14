import UIKit
import CoreData

class PlaylistCoreData {
    
    var testItems = [String]()
    
    func core() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.coreData.managedContext
        let podcastFetch: NSFetchRequest<PodcastPlaylist> = PodcastPlaylist.fetchRequest()
        do {
            let results = try managedContext.fetch(podcastFetch)
            for item in results {
                var currentPlaylistItem: PodcastPlaylistItem?
                let managedContext = appDelegate.coreData.managedContext
                let podcastPlaylistItemFetch: NSFetchRequest<PodcastPlaylistItem> = PodcastPlaylistItem.fetchRequest()
                guard let id = item.playlistId else { return }
                podcastPlaylistItemFetch.predicate = NSPredicate(format: "%K == %@", #keyPath(PodcastPlaylistItem.playlistId), id)
                do {
                    let results = try managedContext.fetch(podcastPlaylistItemFetch)
                    if results.count > 0 {
                        for item in results {
                            if let newTitle = item.episodeTitle {
                                testItems.append(newTitle)
                            }
                        }
                    } else {
                        currentPlaylistItem = PodcastPlaylistItem(context: managedContext)
                        currentPlaylistItem?.episodeTitle = "test"
                        try managedContext.save()
                    }
                } catch let error as NSError {
                    print("Fetch error: \(error) description: \(error.userInfo)")
                }
            }
        } catch let error as NSError {
            print("Fetch error: \(error) description: \(error.userInfo)")
        }
    }
}
