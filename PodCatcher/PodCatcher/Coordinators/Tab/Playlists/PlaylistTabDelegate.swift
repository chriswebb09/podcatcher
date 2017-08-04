import Foundation

protocol PlaylistTabDelegate: CoordinatorDelegate {
    func updatePodcast(with playlistId: String)
}
