import UIKit

final class MediaCellViewModel {
    
    var trackName: String
    var albumImageUrl: UIImage
    
    init(trackName: String, albumImageURL: UIImage) {
        self.trackName = trackName
        self.albumImageUrl = albumImageURL
    }
}
