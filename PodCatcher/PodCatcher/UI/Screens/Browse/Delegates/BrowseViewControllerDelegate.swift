import UIKit

protocol BrowseViewControllerDelegate: class {
    func didSelect(at index: Int)
    func didSelect(at index: Int, with cast: PodcastSearchResult)
    func logout(tapped: Bool)
}
