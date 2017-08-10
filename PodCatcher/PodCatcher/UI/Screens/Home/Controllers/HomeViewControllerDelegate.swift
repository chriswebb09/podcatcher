import UIKit

protocol HomeViewControllerDelegate: class {
    func didSelect(at index: Int, with subscription: Subscription, image: UIImage)
}
