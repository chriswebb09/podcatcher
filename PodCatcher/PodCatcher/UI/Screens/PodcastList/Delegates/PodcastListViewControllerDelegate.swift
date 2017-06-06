import UIKit

protocol PodcastListViewControllerDelegate: class {
    func didSelectTrackAt(at index: Int, with playlist: Caster)
}
