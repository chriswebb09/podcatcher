import Foundation

protocol PlaylistsViewControllerDelegate: class {
    func didAssignPlaylist(with id: String)
}

enum PlaylistsInteractionMode {
    case add, edit
}

enum PlaylistsReference {
    case addPodcast, checkList
}
