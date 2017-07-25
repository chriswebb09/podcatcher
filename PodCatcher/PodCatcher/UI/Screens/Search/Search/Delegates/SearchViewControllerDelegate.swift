import UIKit

protocol SearchViewControllerDelegate: class {
    func didSelect(at index: Int, with cast: PodcastSearchResult)
    func logout(tapped: Bool)
}

protocol PodcastListViewControllerDelegate: class {
    func didSelectPodcastAt(at index: Int, podcast: CasterSearchResult, with episodes: [Episodes])
}
