import UIKit

final class SubscribedPodcastCellViewModel {
    
    var trackName: String
    var albumImageUrl: UIImage
    
    init(trackName: String, albumImageURL: UIImage) {
        self.trackName = trackName
        self.albumImageUrl = albumImageURL
    }
}
