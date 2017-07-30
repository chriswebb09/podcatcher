import UIKit

class InsetButton: UIButton {
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + titleEdgeInsets.left + titleEdgeInsets.right,
                      height: size.height + titleEdgeInsets.top + titleEdgeInsets.bottom)
    }
}
