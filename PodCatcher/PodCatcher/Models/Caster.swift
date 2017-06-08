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
    
    static func testData(completion: @escaping ([Caster]) -> Void) {
        var testCasters = [Caster]()
        var casterOne = Caster()
        let url = URL(string: "http://i.imgur.com/wBr0rsF.jpg")
        UIImage.downloadImageFromUrl(url!.absoluteString) { image in
            DispatchQueue.main.async {
                casterOne.artwork = image
                casterOne.totalPlayTime = 200
                let item = MediaCatcherItem(creatorName: "Test", title: "Title", playtime: 200, playCount: 30, collectionName: "test", audioUrl: url!)
                casterOne.assets.append(item)
                testCasters.append(casterOne)
                casterOne.artwork = image!
                completion(testCasters)
            }
        }
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
