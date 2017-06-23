import UIKit

class BaseMediaControllerDataSource {
    
    var user: PodCatcherUser? 
    
    var image = #imageLiteral(resourceName: "search-button").withRenderingMode(.alwaysOriginal)

    var casters: [Caster]! {
        didSet {
            if let user = user, casters.count == 0 {
                self.casters = user.casts
            }
        }
    }
    
    var count: Int {
        if let caster = casters {
            return caster.count
        } else {
            return 0
        }
    }
    
    init(casters: [Caster]) {
        self.casters = casters
        if let user = user, casters.count == 0 {
            self.casters = user.casts
        }
    }
}