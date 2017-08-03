import UIKit

protocol PodcastListViewControllerDelegate: class {
    func didSelectPodcastAt(at index: Int, podcast: CasterSearchResult, with episodes: [Episodes])
}

protocol SearchViewControllerDelegate: class {
    func didSelect(at index: Int, with cast: PodcastSearchResult)
}
