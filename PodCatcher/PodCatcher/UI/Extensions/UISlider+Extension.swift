import UIKit

extension UISlider {
    func handleImage(with color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: self.bounds.size.height / 8, height: self.bounds.size.height + 10)
        return UIGraphicsImageRenderer(size: rect.size).image { imageContext in
            imageContext.cgContext.setFillColor(color.cgColor)
            imageContext.cgContext.fill(rect.insetBy(dx: 0, dy: 10))
        }
    }
}
