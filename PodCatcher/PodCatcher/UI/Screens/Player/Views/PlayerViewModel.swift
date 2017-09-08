import UIKit

final class PlayerViewModel {
    var state: PlayerState  = .paused
    let title: String
    var totalTimeString: String?
    var currentTimeString: String = "0:00"
    let imageUrl: URL?
    
    var maximumValue: Float!
    
    var currentValue: Float!
    
    init(imageUrl: URL?, title: String) {
        self.imageUrl = imageUrl
        self.title = title
    }
    
    func setTimeStrings(total: String, current: String) {
        totalTimeString = total
        currentTimeString = current
    }
    
    func resetSlide(max: Float, current: Float) {
        maximumValue = max
        currentValue = current
    }
}
