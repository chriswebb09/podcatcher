import UIKit

struct TopPodcastCellViewModel {
    
    var trackName: String
    var podcastImage: UIImage
    
    weak var delegate: TopPodcastCellViewModelDelegate?
    
    init(trackName: String, podcastImage: UIImage) {
        self.trackName = trackName
        self.podcastImage = podcastImage
    }
}
