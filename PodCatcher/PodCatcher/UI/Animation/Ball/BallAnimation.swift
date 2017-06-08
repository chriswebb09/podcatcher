// Credit: NVActivityIndicatorView

import UIKit

final class BallAnimation: AnimationDelegate {
    
    var size: CGSize
    
    init(size: CGSize) {
        self.size = size
    }
    
    func layerWith(size: CGSize, color: UIColor) -> CALayer {
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
    
    func setUpAnimation(in layer: CALayer, size: CGSize, color: UIColor) {
        
        let circleSpacing: CGFloat = 40
        let circleSize: CGFloat = (size.width - 2 * circleSpacing) / 3
        let x: CGFloat = (layer.bounds.size.width - size.width)
        let y: CGFloat = (layer.bounds.size.height - circleSize) / 2
        let duration: CFTimeInterval = 0.75
        let beginTime = CACurrentMediaTime()
        let beginTimes: [CFTimeInterval] = [0.12, 0.24, 0.36]
        let timingFunction = CAMediaTimingFunction(controlPoints: 0.2, 0.68, 0.18, 1.08)
        let animation = CAKeyframeAnimation(keyPath: "transform.scale")
        
        // Animation
        animation.keyTimes = [0, 0.3, 1]
        animation.timingFunctions = [timingFunction, timingFunction]
        animation.values = [1, 0.3, 1]
        animation.duration = duration
        animation.repeatCount = HUGE
        animation.isRemovedOnCompletion = false
        
        // Draw circles
        for i in 0 ..< 3 {
            let circle = layerWith(size: CGSize(width: circleSize, height: circleSize), color: color)
            let frame = CGRect(x: x + circleSize * CGFloat(i) + circleSpacing * CGFloat(i) / 4,
                               y: y,
                               width: circleSize / 4,
                               height: circleSize / 4)
            
            animation.beginTime = beginTime + beginTimes[i]
            circle.frame = frame
            circle.add(animation, forKey: "animation")
            
            layer.addSublayer(circle)
        }
    }
}
