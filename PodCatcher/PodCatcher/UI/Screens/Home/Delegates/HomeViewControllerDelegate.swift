import Foundation

protocol HomeViewControllerDelegate: class {
    func didSelect(at index: Int)
    func didSelect(at index: Int, with cast: PodcastSearchResult)
    func logout(tapped: Bool)
}

protocol MediaControllerDelegate: class {
    func didSelect(at index: Int)
    func logout(tapped: Bool)
}
