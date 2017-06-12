import Foundation

protocol PlayerViewDelegate: class {
    func playButtonTapped()
    func pauseButtonTapped()
    func skipButtonTapped()
    func backButtonTapped()
    func updateTimeValue(time: Double)
}
