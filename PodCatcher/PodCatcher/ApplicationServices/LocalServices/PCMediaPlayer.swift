import MediaPlayer

import UIKit
import CoreData

let noCloudPre = MPMediaPropertyPredicate(
    value: NSNumber(value: false),
    forProperty: MPMediaItemPropertyIsCloudItem
)



class PodcatcherDataStore {
    
    let fetcher: PCMediaPlayer = PCMediaPlayer()
    var podCasters: [NSManagedObject] = []
    
    func pullPodcastsFromUser(completion: @escaping ([Caster]?) -> Void) {
        var lists = [Caster]()
        fetcher.getPlaylists { items in
            for (_ , n) in items.enumerated() {
                print(n)
                lists.append(n.value)
            }
            let listSet = Set(lists)
            for item in Array(listSet) {
                guard let name = item.name else { return }
                self.save(name: name)
            }
            DispatchQueue.main.async {
                completion(Array(listSet))
            }
        }
    }
    
    func save(name: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "PodCaster", in: managedContext)!
        let podCaster = NSManagedObject(entity: entity, insertInto: managedContext)
        podCaster.setValue(name, forKeyPath: "name")
        do {
            try managedContext.save()
            podCasters.append(podCaster)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
}

class PCMediaPlayer {
    
   
    var podcastsQuery: MPMediaQuery!
    var casts = [String: Caster]()
    
    func getPlaylists(completion: @escaping ([String: Caster]) -> Void) {
        MPMediaLibrary.requestAuthorization { [weak self] auth in
            switch auth {
            case .denied:
                fatalError()
            case .notDetermined:
                return
            case .restricted:
                return
            case .authorized:
                
                if let strongSelf = self {
                    if strongSelf.podcastsQuery == nil {
                        strongSelf.podcastsQuery = MPMediaQuery.podcasts()
                    }
                    let itemCollection = strongSelf.getItemCollectionFrom(query: strongSelf.podcastsQuery)
                    guard let newTest = strongSelf.getItemListsFrom(collection: itemCollection) else { return }
                    strongSelf.getPodcastsFromMediaList(mediaLists: newTest)
                    DispatchQueue.main.async {
                        completion(strongSelf.casts)
                    }
                }
            }
        }
    }
    
    func getItemCollectionFrom(query: MPMediaQuery) -> [MPMediaItemCollection]? {
        let podcasts = query.collections?.last
        return [podcasts!]
    }
    
    func getItemListsFrom(collection: [MPMediaItemCollection]?) -> [[MPMediaItem]]? {
        var items: [[MPMediaItem]] = []
        guard let collection = collection else {
            return nil
        }
        for item in collection {
            items.append(item.items)
        }
        return items
    }
    
    func getPodcastsFromMediaList(mediaLists: [[MPMediaItem]]) {
        for list in mediaLists {
            checkPodcastsIn(list: list)
        }
    }
    
    func checkPodcastsIn(list: [MPMediaItem]) {
        for item in list {
            let url = item.assetURL
            if let  artist = item.albumArtist, casts[artist] != nil {
                guard let name = item.albumArtist else { return }
                if let title = item.title, let collectionName = item.albumTitle, let audioUrl = url {
                    var newItem = MediaCatcherItem(creatorName: name,
                                                   title: title,
                                                   playtime: item.playbackDuration,
                                                   playCount: item.playCount,
                                                   collectionName: collectionName,
                                                   audioUrl: audioUrl)
                    newItem.audioItem = item
                    casts[newItem.creatorName]?.assets.append(newItem)
                }
            } else {
                if let name = item.albumArtist, let url = url {
                    var caster = Caster()
                    caster.name = name
                    guard let image = item.artwork?.image(at: CGSize(width: 200, height: 200)) else { return }
                    caster.artwork = image
                    casts[name] = caster
                }
            }
        }
    }
}
