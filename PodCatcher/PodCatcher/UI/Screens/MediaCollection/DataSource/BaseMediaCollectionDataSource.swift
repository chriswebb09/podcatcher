import UIKit

class BaseMediaControllerDataSource {
    
    var image = #imageLiteral(resourceName: "search-button").withRenderingMode(.alwaysOriginal)

    var casters: [Caster]! {
        didSet {
            print(count)
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
    }
}
