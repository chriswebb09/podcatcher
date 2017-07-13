import UIKit

struct TopPodcastCellViewModel {
    
    var trackName: String
    var podcastImage: UIImage
    
    init(trackName: String, podcastImage: UIImage) {
        self.trackName = trackName
        self.podcastImage = podcastImage
    }
}
