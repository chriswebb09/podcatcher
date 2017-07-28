import UIKit

protocol PlayerViewControllerDelegate: class {
    func playButton(tapped: String)
    func pauseButton(tapped: String)
    func skipButton(tapped: String)
    func backButton(tapped: String)
    func navigateBack(tapped: Bool)
    func addItemToPlaylist(item: CasterSearchResult, index: Int)
}

//protocol PlayerViewControllerDelegate: class {
//    func playButton(tapped: Bool)
//    func pauseButton(tapped: Bool)
//    func skipButton(tapped: Bool)
//    func navigateBack(tapped: Bool)
//    func addItemToPlaylist(item: CasterSearchResult, index: Int)
//}

protocol PlayerViewDelegate: class {
    func playButton(tapped: Bool)
    func pauseButton(tapped: Bool)
    func skipButton(tapped: Bool)
    func backButton(tapped: Bool)
    func moreButton(tapped: Bool)
    func updateTimeValue(time: Double)
    func navigateBack(tapped: Bool)
}
