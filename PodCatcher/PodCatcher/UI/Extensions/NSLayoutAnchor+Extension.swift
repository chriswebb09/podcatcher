import UIKit

extension NSLayoutAnchor {
    
    @objc func constrainEqual(_ anchor: NSLayoutAnchor<AnchorType>, constant: CGFloat = 0) {
        let constraint = self.constraint(equalTo: anchor, constant: constant)
        constraint.isActive = true
    }
}
