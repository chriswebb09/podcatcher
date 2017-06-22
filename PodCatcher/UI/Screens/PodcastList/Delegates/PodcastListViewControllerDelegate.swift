import UIKit

protocol PodcastListViewControllerDelegate: class {
    func didSelectPodcastAt(at index: Int, with podcast: Caster)
}
