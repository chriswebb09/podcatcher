import Foundation

enum PlayState {
    case queued, playing, paused, done
}

protocol PlayerViewDelegate: class {
    func playButtonTapped()
    func pauseButtonTapped()
    func skipButtonTapped()
    func backButtonTapped()
}
