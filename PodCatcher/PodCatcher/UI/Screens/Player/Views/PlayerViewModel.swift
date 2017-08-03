import UIKit

final class PlayerViewModel {
    var state: PlayerState  = .paused
    let title: String
    var totalTimeString: String?
    var currentTimeString: String = "0:00"
    let imageUrl: URL?
    
    init(imageUrl: URL?, title: String) {
        self.imageUrl = imageUrl
        self.title = title
    }
}
