import Foundation

protocol PlayerViewControllerDelegate: class {
    func playButton(tapped: Bool)
    func pauseButton(tapped: Bool)
    func skipButton(tapped: Bool)
    func navigateBack(tapped: Bool)
    func addItemToPlaylist(item: CasterSearchResult, index: Int)
}
