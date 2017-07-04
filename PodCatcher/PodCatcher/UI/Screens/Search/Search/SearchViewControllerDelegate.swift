import UIKit

protocol SearchViewControllerDelegate: class {
    func didSelect(at index: Int, with cast: PodcastSearchResult)
    func logout(tapped: Bool)
}
