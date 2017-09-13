import UIKit

protocol BrowseViewControllerDelegate: class {
    func didSelect(at index: Int, with cast: PodcastSearchResult, with imageView: UIImageView)
}
