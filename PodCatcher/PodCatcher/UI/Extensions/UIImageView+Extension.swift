import UIKit

let imageCache: NSCache<NSString, UIImage> = {
    var cache = NSCache<NSString, UIImage>()
    cache.totalCostLimit = 10
    return cache
}()

extension UIImageView {
    
    func addBlurEffect() {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(blurEffectView)
    }
    
    func downloadImage(url: URL) {
        if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
            self.image = cachedImage
            return
        }
        URLSession(configuration: .ephemeral).dataTask(with: URLRequest(url: url)) { data, response, error in
            if error != nil {
                print(error?.localizedDescription ?? "Unknown error")
            }
            DispatchQueue.main.async {
                if let data = data, let image = UIImage(data: data) {
                    imageCache.setObject(image, forKey: url.absoluteString as NSString)
                    self.image = image
                }
            }
            }.resume()
    }
}
