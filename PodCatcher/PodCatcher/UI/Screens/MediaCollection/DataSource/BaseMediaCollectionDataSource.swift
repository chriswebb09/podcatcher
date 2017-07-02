import UIKit

class BaseMediaControllerDataSource: NSObject {
    
    var user: PodCatcherUser?
    
    var casters: [PodcastSearchResult]?
    
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
