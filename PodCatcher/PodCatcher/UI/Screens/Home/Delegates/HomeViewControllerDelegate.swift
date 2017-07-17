import UIKit

protocol HomeViewControllerDelegate: class {
    func didSelect(at index: Int)
    func didSelect(at index: Int, with caster: PodcastSearchResult, image: UIImage)
    func didSelect(at index: Int, with subscription: Subscription, image: UIImage)
    func logout(tapped: Bool)
}
