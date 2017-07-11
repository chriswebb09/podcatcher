import UIKit

struct CasterSearchResult: PodcastSearchResult {
    
    var podcastSearchType: ResultType?
    var podcastArtist: String?
    var podcastArtUrlString: String?
    var podcastTitle: String?
    var episodes = [Episodes]()
    var category = ""
    var id: String!
    var feedUrl: String?
    var itunesUrlString: String?
    var index: Int!
    
    init() {
        
    }
    
    init?(json: [String: Any]) {
        
        guard let artUrl = json["artworkUrl600"] as? String else { return }
        guard let artistName = json["artistName"] as? String else { return }
        guard let trackName = json["trackName"] as? String else { return }
        guard let title = json["collectionName"] as? String else { return }
        guard let releaseDate = json["releaseDate"] as? String else { return }
        guard let id = json["collectionId"] as? Int else { return }
        guard let feedUrl = json["feedUrl"] as? String else { return }
        let episode = Episodes(mediaUrlString: "", audioUrlSting: "", title: trackName, date: releaseDate, description: "test", duration: 29134, audioUrlString: nil, stringDuration: nil)
        self.episodes.append(episode)
        self.podcastArtUrlString = artUrl
        self.podcastArtist = artistName
        self.podcastTitle = title
        self.feedUrl = feedUrl
        self.id = String(describing: id)
        
    }
    
}

extension CasterSearchResult: Equatable {
    
    static func ==(lhs: CasterSearchResult, rhs: CasterSearchResult) -> Bool {
        return lhs.id == rhs.id
    }
}

extension CasterSearchResult: ContentProvider {
    var mediaItems: [Content] {
        return self.episodes
    }

    var providerId: String {
        return self.id
    }

    var feedUrlString: String {
        return self.feedUrl!
    }
    
}
