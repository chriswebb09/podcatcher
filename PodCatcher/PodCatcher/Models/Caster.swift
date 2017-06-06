import UIKit

struct Caster {
    
    var name: String?
    var artwork: UIImage?
    var assetURL: URL?
    var tags: [String]
    var assets: [MediaCatcherItem]
    var totalPlayTime: Double?
    
    init() {
        self.totalPlayTime = 0
        self.assets = []
        self.tags = []
    }
}

extension Caster: Equatable {
    static func ==(lhs: Caster, rhs: Caster) -> Bool {
        return lhs.name == rhs.name
    }
}

extension Caster: Hashable {

    var hashValue: Int {
        guard let name = name else { return 0 }
        return name.hashValue 
    }
}
