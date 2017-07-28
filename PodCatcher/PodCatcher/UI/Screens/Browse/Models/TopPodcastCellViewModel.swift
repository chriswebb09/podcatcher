import UIKit

protocol TopPodcastCellViewModelDelegate: class {
    func cellViewModel(_ cellViewModel: TopPodcastCellViewModel, canDisplay image: UIImage) -> Bool
}

struct TopPodcastCellViewModel {
    
    var trackName: String
    var podcastImage: UIImage
    
    weak var delegate: TopPodcastCellViewModelDelegate?
    
    init(trackName: String, podcastImage: UIImage) {
        self.trackName = trackName
        self.podcastImage = podcastImage
    }
}
