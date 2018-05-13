import UIKit

class WebDataCache {
    
    static let imageCache: NSCache<NSString, UIImage> = {
        var cache = NSCache<NSString, UIImage>()
        cache.name = "ImageCache"
        cache.countLimit = 20
        cache.totalCostLimit = 10 * 1024 * 1024
        return cache
    }()
}


