import UIKit

protocol SearchViewControllerDelegate: class {
    func didSelect(at index: Int)
    func logout(tapped: Bool)
}
