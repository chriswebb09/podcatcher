import UIKit

extension CGRect {
    var center: CGPoint {
        get {
            return CGPoint(x: size.width / 2, y: size.height / 2)
        }
        set {
            self.origin = CGPoint(x: newValue.x - size.width / 2, y: newValue.y - size.height / 2)
        }
    }
}

internal extension CGFloat {
    
    internal func isNear(to number: CGFloat, delta: CGFloat) -> Bool {
        return self >= (number - delta) && self <= (number + delta)
    }
    
    internal func map(from firstBounds: (CGFloat, CGFloat), to secondBounds: (CGFloat, CGFloat)) -> CGFloat {
        guard self > firstBounds.0 else {
            return secondBounds.0
        }
        
        guard self < firstBounds.1 else {
            return secondBounds.1
        }
        
        let firstBoundsDelta = firstBounds.1 - firstBounds.0
        let ratio = (self - firstBounds.0) / firstBoundsDelta
        return secondBounds.0 + ratio * (secondBounds.1 - secondBounds.0)
    }
    
    internal func bounded(by bounds: (CGFloat, CGFloat)) -> CGFloat {
        return Swift.max(bounds.0, Swift.min(bounds.1, self))
    }
}
