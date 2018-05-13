import Foundation

//protocol PlaylistsViewControllerDelegate: class {
//    func didAssignPlaylist(with id: String)
//  //  func playlistSelected(for caster: PodcastPlaylist)
//}
//


protocol PlaylistsViewControllerDelegate: class {
    func didSelect(title: String)
    func updateNavItems()
    func createPlaylist(title: String)
    func setMiniPlayer(miniPlayer: MiniPlayerViewController)
    // func updateNavTitle()
}
