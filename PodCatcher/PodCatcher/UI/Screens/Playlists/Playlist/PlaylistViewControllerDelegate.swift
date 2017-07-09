import UIKit

protocol PlaylistViewControllerDelegate: class {
    func didSelectPodcastAt(at index: Int, podcast: CasterSearchResult, with episodes: [Episodes])
}
