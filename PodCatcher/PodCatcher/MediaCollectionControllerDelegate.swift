import Foundation

protocol MediaControllerDelegate: class {
    func didSelectCaster(at index: Int, with playlist: Caster)
    func logoutTapped(logout: Bool)
}
