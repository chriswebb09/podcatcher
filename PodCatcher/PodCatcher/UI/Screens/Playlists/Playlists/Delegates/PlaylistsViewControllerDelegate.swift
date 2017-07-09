import UIKit

protocol PlaylistsViewControllerDelegate: class {
    func didAssign(podcast: PodcastPlaylistItem)
    func didAssignPlaylist(playlist: PodcastPlaylist)
    func didAssignPlaylist(with id: String)
    func didSelect(at index: Int, with playlist: Playlist)
    func logout(tapped: Bool)
}
