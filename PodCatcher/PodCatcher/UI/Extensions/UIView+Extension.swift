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
}

extension UIView {
    
    public func constrainEqual(_ attribute: NSLayoutAttribute, to: AnyObject, multiplier: CGFloat = 1, constant: CGFloat = 0) {
        constrainEqual(attribute, to: to, attribute, multiplier: multiplier, constant: constant)
    }
    
    public func constrainEqual(_ attribute: NSLayoutAttribute, to: AnyObject, _ toAttribute: NSLayoutAttribute, multiplier: CGFloat = 1, constant: CGFloat = 0) {
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: self, attribute: attribute, relatedBy: .equal, toItem: to, attribute: toAttribute, multiplier: multiplier, constant: constant)
            ]
        )
    }
    
    public func constrainEdges(to other: UILayoutGuide) {
        topAnchor.constrainEqual(other.topAnchor)
        bottomAnchor.constrainEqual(other.bottomAnchor)
        leadingAnchor.constrainEqual(other.leadingAnchor)
        trailingAnchor.constrainEqual(other.trailingAnchor)
    }
    
    public func constrainEdges(toMarginOf view: UIView) {
        constrainEqual(.top, to: view, .topMargin)
        constrainEqual(.leading, to: view, .leadingMargin)
        constrainEqual(.trailing, to: view, .trailingMargin)
        constrainEqual(.bottom, to: view, .bottomMargin)
    }
    
    /// If the `view` is nil, we take the superview.
    public func center(inView view: UIView? = nil) {
        guard let container = view ?? self.superview else { fatalError() }
        centerXAnchor.constrainEqual(container.centerXAnchor)
        centerYAnchor.constrainEqual(container.centerYAnchor)
    }
    
    public var debugBorder: UIColor? {
        get { return layer.borderColor.map { UIColor(cgColor: $0) } }
        set {
            layer.borderColor = newValue?.cgColor
            layer.borderWidth = newValue != nil ? 1 : 0
        }
    }
    
    public static func activateDebugBorders(_ views: [UIView]) {
        let colors: [UIColor] = [.magenta, .orange, .green, .blue, .red]
        for (view, color) in zip(views, colors.cycled()) {
            view.debugBorder = color
        }
    }
}





