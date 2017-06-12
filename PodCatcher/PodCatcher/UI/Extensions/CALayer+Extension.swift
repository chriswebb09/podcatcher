import UIKit

extension CALayer {
    
    func setCellShadow(contentView: UIView) {
        let shadowOffsetWidth: CGFloat = contentView.bounds.height * CALayerConstants.shadowWidthMultiplier
        let shadowOffsetHeight: CGFloat = contentView.bounds.width * CALayerConstants.shadowHeightMultiplier
        shadowColor = UIColor.black.cgColor
        shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight)
        shadowRadius =  1.8
        shadowOpacity = 0.7
    }
    
    
    static func createGradientLayer(layer: CALayer, bounds: CGRect) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [UIColor(red:0.31, green:0.49, blue:0.63, alpha:1.0).cgColor, UIColor(red:0.18, green:0.27, blue:0.33, alpha:1.0).cgColor]
        layer.addSublayer(gradientLayer)
    }
    
    func podcastCell(viewRadius: CGFloat) {
        shadowColor = UIColor.lightGray.cgColor
        shadowOffset = CGSize(width: 0, height: 2.0)
        shadowRadius = 0.5
        shadowOpacity = 0.3
        masksToBounds = false;
        shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: viewRadius).cgPath
    }
    
}
