import Foundation

protocol PlayableItem {
    var title: String { get set }
    var audioItem: AudioFile { get set }
    var artworkUrlString: String { get set }
    var duration: Double { get set }
}
