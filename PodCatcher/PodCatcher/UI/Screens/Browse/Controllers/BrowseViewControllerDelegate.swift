import Foundation

protocol BrowseViewControllerDelegate: class {
    func didSelect(at index: Int, with cast: PodcastSearchResult)
}
