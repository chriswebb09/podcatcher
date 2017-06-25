import UIKit
import CoreData

struct Caster {
    var podCasters: [NSManagedObject] = []
    
    var name: String?
    var artwork: UIImage? {
        didSet {
            guard let artwork = artwork else { return }
            save(image: artwork)
        }
    }
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
        
        guard let url = URL(string: "http://i.imgur.com/wBr0rsF.jpg") else { return }
        
        UIImage.downloadImageFromUrl(url.absoluteString) { image in
            DispatchQueue.main.async {
                casterOne.artwork = image
                casterOne.totalPlayTime = 200
                let item = MediaCatcherItem(creatorName: "Test", title: "Title", playtime: 200, playCount: 30, collectionName: "test", audioUrl: url)
                casterOne.assets.append(item)
                testCasters.append(casterOne)
                guard let image = image else { return }
                casterOne.artwork = image
                completion(testCasters)
            }
        }
    }
    
    mutating func save(image: UIImage) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let imageData = UIImageJPEGRepresentation(image, 1.0)
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "PodCaster", in: managedContext)!
        let podCaster = NSManagedObject(entity: entity, insertInto: managedContext)
        podCaster.setValue(imageData, forKeyPath: "image")
        do {
            try managedContext.save()
            podCasters.append(podCaster)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
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
