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



extension UIImageView {
    
    func performUIUpdate(using closure: @escaping () -> Void) {
        // If we are already on the main thread, execute the closure directly
        if Thread.isMainThread {
            closure()
        } else {
            DispatchQueue.main.async(execute: closure)
        }
    }
    
    func addBlurEffect() {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(blurEffectView)
    }
    
    func downloadImage(url: URL) {
        self.image = nil
        let urlconfig = URLSessionConfiguration.ephemeral
        urlconfig.timeoutIntervalForRequest = 8
        let session = URLSession(configuration: urlconfig, delegate: nil, delegateQueue: nil)
        let request = URLRequest(url: url,  cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 8)
        session.dataTask(with: request) { data, response, error in
            if error != nil {
                print(error?.localizedDescription ?? "Unknown error")
                return
            }
            self.performUIUpdate {
                self.image = nil
            }
            
            if let data = data, let image = UIImage(data: data) {
                
                self.performUIUpdate {
                    self.image = image
                }
            }}.resume()
    }
    
    func dropShadow() {
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOpacity = 0.25
        self.layer.shadowOffset = CGSize(width: -0.9, height: 0.8)
        self.layer.shadowRadius = 0.6
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }
}
