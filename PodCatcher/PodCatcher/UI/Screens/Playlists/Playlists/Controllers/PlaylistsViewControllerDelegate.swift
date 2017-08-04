import Foundation

protocol PlaylistsViewControllerDelegate: class {
    func didAssignPlaylist(with id: String)
    func playlistSelected(for caster: PodcastPlaylist)
}

enum PlaylistsInteractionMode {
    case add, edit
}

enum PlaylistsReference {
    case addPodcast, checkList
}
