import UIKit

extension UIView {
    
    func addView(view: UIView, type: ViewType) {
        switch type {
        case .full:
            view.frame = UIScreen.main.bounds
            addSubview(view)
            view.layoutSubviews()
        case .element:
            addSubview(view)
            view.layoutSubviews()
        }
    }
}


extension UIImage {
    func scaleToSize(_ newSize: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
}
