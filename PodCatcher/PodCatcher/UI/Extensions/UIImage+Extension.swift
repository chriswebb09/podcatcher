import UIKit

extension UIImage {
    
    static func getImageWithColor(color: UIColor, size: CGSize) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    
    func scaleToSize(_ newSize: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    static func downloadImageFromUrl(_ url: String, completionHandler: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: url) else {
            completionHandler(nil)
            return
        }
        let task: URLSessionDataTask = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) -> Void in
            guard let httpURLResponse = response as? HTTPURLResponse , httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data , error == nil,
                let image = UIImage(data: data) else {
                    completionHandler(nil)
                    return
            }
            completionHandler(image)
        })
        task.resume()
    }
    
    static func rotate(image: UIImage, withRotation radians: CGFloat) -> UIImage? {
        
        guard let cgImage = image.cgImage else { return nil }
        
        let maxSize = CGFloat(max(image.size.width, image.size.height))
        let intMaxSize = Int(maxSize)
        guard let colorSpace = cgImage.colorSpace else { return nil }
        
        guard let context = CGContext.init(data: nil,
                                           width: intMaxSize,
                                           height: intMaxSize,
                                           bitsPerComponent: cgImage.bitsPerComponent,
                                           bytesPerRow: 0,
                                           space: colorSpace,
                                           bitmapInfo: cgImage.bitmapInfo.rawValue) else { return nil }
        
        var drawRect = CGRect.zero
        drawRect.size = image.size
        
        let originX = (maxSize - image.size.width) * 0.5
        let originY = (maxSize - image.size.height) * 0.5
        
        let drawOrigin = CGPoint(x: originX, y: originY)
        
        drawRect.origin = drawOrigin
        
        var transform = CGAffineTransform.identity
        let transformer = maxSize * 0.5
        transform = transform.translatedBy(x: transformer, y: transformer)
        transform = transform.rotated(by: radians)
        let translater = maxSize * -0.5
        transform = transform.translatedBy(x: translater, y: translater)
        
        context.concatenate(transform)
        context.draw(cgImage, in: drawRect)
        guard let rotatedImage = context.makeImage() else { return nil }
        return UIImage(cgImage: rotatedImage)
    }
}

