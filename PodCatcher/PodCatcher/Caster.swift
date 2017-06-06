import UIKit

struct Caster {
    var name: String
    var artwork: UIImage
    var assetURL: URL
    var assets: [MediaCatcherItem]    
}

extension Caster: Equatable {

    static func ==(lhs: Caster, rhs: Caster) -> Bool {
        return lhs.name == rhs.name
    }
}

extension Caster: Hashable {

    var hashValue: Int {
        return name.hashValue 
    }

    
}
