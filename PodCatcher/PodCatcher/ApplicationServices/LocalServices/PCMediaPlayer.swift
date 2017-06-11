import MediaPlayer

class PCMediaPlayer {
    
    var myPodcastsQuery: MPMediaQuery!
    var casts = [String: Caster]()
    
    var casters = [Caster]()
    
    var myMPMusicPlayerController = MPMusicPlayerController()
    
    func getPlaylists(completion: @escaping ([String: Caster], [Caster]?) -> Void) {
        MPMediaLibrary.requestAuthorization { auth in
            switch auth {
            case .denied:
                fatalError()
            case .notDetermined:
                return
            case .restricted:
                return
            case .authorized:
                if self.myPodcastsQuery == nil {
                    self.myPodcastsQuery = MPMediaQuery.podcasts()
                }
                
                let itemCollection = self.getItemCollectionFrom(query: self.myPodcastsQuery)
                let newTest = self.getItemListsFrom(collection: itemCollection)
                self.getPodcastsFromMediaList(mediaLists: newTest)
                for (_ , n) in self.casts.enumerated() {
                    print(n.value)
                    self.casters.append(n.value)
                }
                DispatchQueue.main.async {
                    completion(self.casts, self.casters)
                }
                
            }
        }
    }
    
    func getItemCollectionFrom(query: MPMediaQuery) -> [MPMediaItemCollection]? {
        guard let myPodcastsQuery = myPodcastsQuery else { return nil }
        let podcasts = myPodcastsQuery.collections
        return podcasts
    }
    
    
    func getItemListsFrom(collection: [MPMediaItemCollection]?) -> [[MPMediaItem]] {
        var itemy: [[MPMediaItem]] = []
        for item in collection! {
            itemy.append(item.items)
        }
        return itemy
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

