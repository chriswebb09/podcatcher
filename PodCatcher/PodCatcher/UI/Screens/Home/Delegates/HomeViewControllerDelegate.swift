import Foundation

protocol HomeViewControllerDelegate: class {
    func didSelect(at index: Int)
    func didSelect(at index: Int, with cast: PodcastSearchResult)
    func didSelect(at index: Int, with subscription: Subscription)
    func logout(tapped: Bool)
}
