import Foundation

enum ResultType {
    case podcast, topic, caster, term
}

protocol PodcastSearchResult {
    var podcastArtUrlString: String? { get set }
    var podcastTitle: String? { get set }
    var podcastArtist: String? { get set }
    var podcastSearchType: ResultType? { get set }
}
