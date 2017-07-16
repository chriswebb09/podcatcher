import UIKit

protocol PlaylistsViewControllerDelegate: class {
    func didAssignPlaylist(with id: String)
    func didSelect(at index: Int, with playlist: Playlist)
    func logout(tapped: Bool)
}
