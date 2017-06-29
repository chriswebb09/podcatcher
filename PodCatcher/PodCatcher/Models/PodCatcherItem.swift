import UIKit
import MediaPlayer

struct MediaCatcherItem {
    
    var creatorName: String
    var title: String
    var playtime: Double
    var playCount: Int?
    var collectionName: String
    var audioUrl: URL?
    var audioItem: MPMediaItem?
    var tags: [String]
    var details: String = "" 
    
    init(creatorName: String, title: String, playtime: Double, playCount: Int, collectionName: String, audioUrl: URL?) {
        self.creatorName = creatorName
        self.title = title
        self.playtime = playtime
        self.collectionName = collectionName
        self.audioUrl = audioUrl
        self.tags = []
    }
}

extension MediaCatcherItem: Equatable {

    static func ==(lhs: MediaCatcherItem, rhs: MediaCatcherItem) -> Bool {
        return lhs.audioUrl == rhs.audioUrl
    }
}
