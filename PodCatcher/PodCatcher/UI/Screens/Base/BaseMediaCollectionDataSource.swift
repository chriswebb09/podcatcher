import UIKit

class BaseMediaControllerDataSource: NSObject {
    
    var casters: [PodcastItem]?
    
    var count: Int {
        if let caster = casters {
            return caster.count
        } else {
            return 0
        }
    }
    
    override init() {
        self.casters = nil
    }
}
