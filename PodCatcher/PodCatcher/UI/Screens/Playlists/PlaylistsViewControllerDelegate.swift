import UIKit

protocol PlaylistsViewControllerDelegate: class {
    func didSelect(at index: Int, with playlist: Playlist)
    func logout(tapped: Bool)
}
