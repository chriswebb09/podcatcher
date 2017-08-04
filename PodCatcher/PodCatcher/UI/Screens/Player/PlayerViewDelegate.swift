import UIKit

protocol PlayerViewDelegate: class {
    func playPause(tapped: Bool)
    func skipButton(tapped: Bool)
    func backButton(tapped: Bool)
    func moreButton(tapped: Bool)
    func navigateBack(tapped: Bool)
}
