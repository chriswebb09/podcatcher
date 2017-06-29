import MediaPlayer

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
    
    func getPodcastsFromMediaList(mediaLists: [[MPMediaItem]]) {
        for list in mediaLists {
            checkPodcastsIn(list: list)
        }
    }
    
    func checkItem(item: MPMediaItem) -> Bool {
        guard let name = item.artist else { return false }
        if casts[name] != nil {
            return true
        }
        return false
    }
    
    func createCatcher(from item: MPMediaItem) {
        guard let name = item.albumArtist else { return }
        if let url = item.assetURL, let title = item.title, let collectionName = item.albumTitle {
            var newItem = MediaCatcherItem(creatorName: name,
                                           title: title,
                                           playtime: item.playbackDuration,
                                           playCount: item.playCount,
                                           collectionName: collectionName,
                                           audioUrl: url)
            newItem.audioItem = item
            casts[newItem.creatorName]?.assets.append(newItem)
        }
    }
}

extension PCMediaPlayer: MediaItemGetter {
    
    func checkPodcastsIn(list: [MPMediaItem]) {
        for item in list {
            if checkItem(item: item) {
                createCatcher(from: item)
            } else {
                addToCasts(item: item)
            }
        }
    }
}

extension PCMediaPlayer: CollectorFromQuery {
    
    func addToCasts(item: MPMediaItem) {
        if let name = item.albumArtist {
            var caster = Caster()
            caster.name = name
            guard let image = item.artwork?.image(at: CGSize(width: 200, height: 200)) else { return }
            caster.artwork = image
            casts[name] = caster
        }
    }
}
