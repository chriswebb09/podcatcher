import Foundation

struct TermSearchResult: PodcastSearchResult {
    var podcastSearchType: ResultType?
    var podcastArtist: String?
    var podcastTitle: String?
    var podcastArtUrlString: String?
}
