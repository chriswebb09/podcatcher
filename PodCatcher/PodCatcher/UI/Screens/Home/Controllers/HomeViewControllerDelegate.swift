import UIKit

protocol HomeViewControllerDelegate: class {
    func selectedItem(at: Int, podcast: Podcaster, imageView: UIImageView)
    func updateNavigation(for isNil: Bool)
    func updateNavigationItems()
}

