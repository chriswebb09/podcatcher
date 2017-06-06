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
                if let name = item.albumArtist, let title = item.title, let collectionName = item.albumTitle {
                    let item = MediaCatcherItem(creatorName: name, title: title, collectionName: collectionName, audioUrl: url)
                    casts[item.creatorName]?.assets.append(item)
                }
            } else {
                if let name = item.albumArtist, let url = url, let art = art {
                    casts[name] = Caster(name: name, artwork: art, assetURL: url, assets: [])
                }
                
            }
        }
    }
}

