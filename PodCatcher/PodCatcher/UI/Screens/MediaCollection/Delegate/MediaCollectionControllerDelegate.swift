import Foundation

protocol MediaControllerDelegate: class {
    func didSelect(at index: Int)
    func logout(tapped: Bool)
}
