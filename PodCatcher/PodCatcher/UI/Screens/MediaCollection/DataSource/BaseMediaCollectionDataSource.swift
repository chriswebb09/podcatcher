import UIKit

class BaseMediaControllerDataSource: NSObject {
    
    var user: PodCatcherUser?
    
    var casters: [PodcastSearchResult]?
    
//    var casters = [PodcastSearchResult]! {
//       // didSet {
//            //            if let user = user, casters.count == 0 {
//            //                self.casters = user.casts
//            //            }
//            //        }
//    }

//    var casters: [Caster]! {
//        didSet {
//            if let user = user, casters.count == 0 {
//                self.casters = user.casts
//            }
//        }
//    }
    
    var count: Int {
        if let caster = casters {
            return caster.count
        } else {
            return 0
        }
    }
    
    override init() {
        self.casters = nil
//        if let user = user, casters.count == 0 {
//            self.casters = user.casts
//        }
    }
}
