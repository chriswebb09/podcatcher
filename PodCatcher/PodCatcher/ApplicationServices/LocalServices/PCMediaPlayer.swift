import MediaPlayer

class PCMediaPlayer {
    
    var podcastsQuery: MPMediaQuery!
    var casts = [String: Caster]()
    var casters = [Caster]()
    
    func getPlaylists(completion: @escaping ([String: Caster], [Caster]?) -> Void) {
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
                    for (_ , n) in strongSelf.casts.enumerated() {
                        strongSelf.casters.append(n.value)
                    }
                    DispatchQueue.main.async {
                        completion(strongSelf.casts, strongSelf.casters)
                    }
                }
            }
        }
    }
    
    func getItemCollectionFrom(query: MPMediaQuery) -> [MPMediaItemCollection]? {
        guard let myPodcastsQuery = podcastsQuery else { return nil }
        let podcasts = myPodcastsQuery.collections
        return podcasts
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
            let art = item.artwork?.image(at: CGSize(width: 200, height: 200))
            let url = item.assetURL
            if casts[item.albumArtist!] != nil {
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
                if let name = item.albumArtist, let url = url, let art = art {
                    var caster = Caster()
                    caster.name = name
                    caster.assetURL = url
                    caster.artwork = art
                    casts[name] = caster
                }
            }
        }
    }
}

