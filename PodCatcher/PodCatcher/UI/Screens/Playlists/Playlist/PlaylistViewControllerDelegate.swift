import UIKit

protocol PlaylistViewControllerDelegate: class {
    func didSelectPodcast(at index: Int, with episodes: [PodcastPlaylistItem])
//    func didSelectPodcastAt(at index: Int, podcast: CasterSearchResult, with episodes: [Episodes])
}
