import UIKit

protocol HomeViewControllerDelegate: class {
    func didSelect(at index: Int, with subscription: Subscription, image: UIImage)
    func didSelect(at index: Int, with subscription: Subscription, image: UIImage, imageView: UIImageView)
}
