import UIKit

protocol PlayerViewControllerDelegate: class {
    func playButton(tapped: String)
    func pauseButton(tapped: String)
    func skipButton(tapped: String)
    func playPaused(tapped: Bool)
    func backButton(tapped: String)
    func navigateBack(tapped: Bool)
    func addItemToPlaylist(item: CasterSearchResult, index: Int)
}
