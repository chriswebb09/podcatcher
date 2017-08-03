import UIKit

protocol PlayerViewDelegate: class {
    func playButton(tapped: Bool)
    func pauseButton(tapped: Bool)
    func playPause(tapped: Bool)
    func skipButton(tapped: Bool)
    func backButton(tapped: Bool)
    func moreButton(tapped: Bool)
    func navigateBack(tapped: Bool)
}
