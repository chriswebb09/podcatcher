import Foundation

protocol AudioFilePlayerDelegate: class {
    func updateProgress(progress: Double)
    func trackFinishedPlaying()
}
