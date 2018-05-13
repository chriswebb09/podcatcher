import UIKit

protocol PodcastListViewControllerDelegate: class {
    func didSelectPodcastAt(at index: Int, podcast: PodcastItem, with episodes: [Episode])
    func saveFeed(item: Podcast, podcastImage: UIImage, episodesCount: Int)
    func navigateBack(tapped: Bool)
}

