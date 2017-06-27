import UIKit

class CasterSearchResult: PodcastSearchResult {
    var podcastSearchType: ResultType?
    var podcastArtist: String?
    var podcastArtUrlString: String?
    var podcastTitle: String?
    var episodes = [Episodes]()
    var id: String!
}

extension CasterSearchResult: Equatable {

    static func ==(lhs: CasterSearchResult, rhs: CasterSearchResult) -> Bool {
        return lhs.id == rhs.id
    }

    
}