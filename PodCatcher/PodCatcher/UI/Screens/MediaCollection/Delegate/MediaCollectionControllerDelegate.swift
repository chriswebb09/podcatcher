import Foundation

protocol MediaControllerDelegate: class {
    func didSelect(at index: Int)
    func logoutTapped(logout: Bool)
}
