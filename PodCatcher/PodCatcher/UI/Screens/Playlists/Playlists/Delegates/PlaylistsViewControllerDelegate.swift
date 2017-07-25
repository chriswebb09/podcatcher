import UIKit

protocol PlaylistsViewControllerDelegate: class {
    func didAssignPlaylist(with id: String)
    func logout(tapped: Bool)
}
