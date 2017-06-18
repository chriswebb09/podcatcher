import UIKit

extension CALayer {
    
    func setCellShadow(contentView: UIView) {
        let shadowOffsetWidth: CGFloat = contentView.bounds.height * CALayerConstants.shadowWidthMultiplier
        let shadowOffsetHeight: CGFloat = contentView.bounds.width * CALayerConstants.shadowHeightMultiplier
        shadowColor = UIColor.black.cgColor
        shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight)
        shadowRadius =  1.8
        shadowOpacity = 0.8
    }
    
    static func drawCircleLayerWith(size: CGSize, color: UIColor) -> CALayer {
        let layer: CAShapeLayer = CAShapeLayer()
        let path: UIBezierPath = UIBezierPath()
        path.addArc(withCenter: CGPoint(x: size.width , y: size.height),
                    radius: size.width / 2,
                    startAngle: 0,
                    endAngle: CGFloat(2 * Double.pi),
                    clockwise: false)
        layer.fillColor = color.cgColor
        layer.path = path.cgPath
        layer.frame = CGRect(x: 0, y: 0, width: size.width / 2, height: size.height / 2)
        return layer
    }
    
    static func createGradientLayer(with colors: [CGColor], layer: CALayer, bounds: CGRect) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = colors 
        layer.addSublayer(gradientLayer)
        
    }
    
    func podcastCell(viewRadius: CGFloat) {
        shadowColor = UIColor.lightGray.cgColor
        shadowOffset = CGSize(width: 0, height: 2.0)
        shadowRadius = 3
        shadowOpacity = 0.2
        masksToBounds = false;
        shadowPath = UIBezierPath(roundedRect:self.bounds, cornerRadius: viewRadius).cgPath
    }
    
}
