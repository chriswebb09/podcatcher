import Foundation

protocol PlayerViewDelegate: class {
    func playButtonTapped()
    func pauseButtonTapped()
    func skipButtonTapped()
    func backButtonTapped()
    func moreButton(tapped: Bool)
    func updateTimeValue(time: Double)
    func navigateBack(tapped: Bool)
}
