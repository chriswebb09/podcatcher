import Foundation

protocol PlaylistViewControllerDelegate: class {
    func didSelectPodcast(at index: Int, with episodes: [PodcastPlaylistItem], caster: CasterSearchResult)
}

enum PlaylistMode {
    case player, list
}
