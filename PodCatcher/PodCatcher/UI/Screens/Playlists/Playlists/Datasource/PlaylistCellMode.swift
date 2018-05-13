import Foundation

enum PlaylistCellMode {
    case select, delete
}

class PlaylistCellViewModel: CellViewModel {
    
    var mainImage: UIImage! {
        didSet {
            podcastImage = mainImage
        }
    }
    
    var titleText: String! {
        didSet {
            playlistName = titleText
        }
    }
    
    var playlistName: String!
    var podcastImage: UIImage!
    var playlist: Playlist
    
    weak var delegate: TopPodcastCellViewModelDelegate?
    
    init(podcast: Playlist) {
        self.playlist = podcast
    }
}
