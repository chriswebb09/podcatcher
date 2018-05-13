import UIKit

extension UIView {
    func fadeIn(_ duration: TimeInterval = 0.1, delay: TimeInterval = 0.0, completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.alpha = 1.0
        }, completion: completion)  }
    
    func fadeOut(_ duration: TimeInterval = 0.1, delay: TimeInterval = 0.0, completion: @escaping (Bool) -> Void = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.alpha = 0.0
        }, completion: completion)
    }
}

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
    
    func embed(other view: UIView) {
        embed(other: view, insets: .zero)
    }
    
    func embed(other view: UIView, insets: UIEdgeInsets) {
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        NSLayoutConstraint.activate([view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: insets.left), view.trailingAnchor.constraint(equalTo: trailingAnchor, constant: insets.right), view.topAnchor.constraint(equalTo: topAnchor, constant: insets.top), view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: insets.bottom)])
    }
    
    func subview<T: UIView>() -> T? {
        return subviews.first(where: { $0 is T }) as? T
    }
    
    func add(_ subviews: UIView...) {
        if #available(iOS 11.0, *) {
            subviews.forEach(addSubview)
        }
    }
    
    func add(_ subviews: [UIView]) {
        if #available(iOS 10, *) {
            print(subviews)
            for view in subviews {
                addSubview(view)
            }
        }
    }
    
    func makeSnapshot() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(bounds.size, true, 0.0)
        drawHierarchy(in: bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
 
    
    func makeEndSnapshot() -> UIImage? {
        let layer = UIApplication.shared.keyWindow!.layer
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, scale);
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let screenshot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return screenshot
    }
}

extension UIColor {
    static func colorFromRGB(_ red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat = 1.0) -> UIColor {
        func amount(_ amount: CGFloat, with alpha: CGFloat) -> CGFloat {
            return (1 - alpha) * 255 + alpha * amount
        }
        
        let red = amount(red, with: alpha)/255
        let green = amount(green, with: alpha)/255
        let blue = amount(blue, with: alpha)/255
        return UIColor(red: red, green: green, blue: blue, alpha: 1)
    }
}


extension UIView {
    
    
    static func findSubViewWithFirstResponder(_ view: UIView) -> UIView? {
        let subviews = view.subviews
        if subviews.count == 0 {
            return nil
        }
        for subview: UIView in subviews {
            if subview.isFirstResponder {
                return subview
            }
            return findSubViewWithFirstResponder(subview)
        }
        return nil
    }
    
    func constrainEqual(_ attribute: NSLayoutAttribute, to: AnyObject, multiplier: CGFloat = 1, constant: CGFloat = 0) {
        constrainEqual(attribute, to: to, attribute, multiplier: multiplier, constant: constant)
    }
    
    func constrainEqual(_ attribute: NSLayoutAttribute, to: AnyObject, _ toAttribute: NSLayoutAttribute, multiplier: CGFloat = 1, constant: CGFloat = 0) {
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: self, attribute: attribute, relatedBy: .equal, toItem: to, attribute: toAttribute, multiplier: multiplier, constant: constant)
            ]
        )
    }

    func constrainEdges(toMarginOf view: UIView) {
        constrainEqual(.top, to: view, .topMargin)
        constrainEqual(.leading, to: view, .leadingMargin)
        constrainEqual(.trailing, to: view, .trailingMargin)
        constrainEqual(.bottom, to: view, .bottomMargin)
    }

}
