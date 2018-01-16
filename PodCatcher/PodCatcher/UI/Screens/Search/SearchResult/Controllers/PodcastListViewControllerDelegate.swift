import UIKit

protocol PodcastListViewControllerDelegate: class {
    func didSelectPodcastAt(at index: Int, podcast: CasterSearchResult, with episodes: [Episode])
    func saveFeed(item: CasterSearchResult, podcastImage: UIImage, episodesCount: Int)
    func navigateBack(tapped: Bool)
}

