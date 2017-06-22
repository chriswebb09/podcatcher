import Foundation

protocol AudioFilePlayerDelegate: class {
    func updateProgress(progress: Double)
    func trackDurationCalculated(stringTime: String, timeValue: Float64)
    func trackFinishedPlaying()
}
