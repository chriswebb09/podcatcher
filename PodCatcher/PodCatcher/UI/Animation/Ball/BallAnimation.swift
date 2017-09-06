// Credit: NVActivityIndicatorView

import UIKit

final class BallAnimation: AnimationDelegate {
    
    var size: CGSize
    
    init(size: CGSize) {
        self.size = size
    }
    
    func setUpAnimation(in layer: CALayer, size: CGSize, color: UIColor) {
        
        let circleSpacing: CGFloat = 40
        let circleSize: CGFloat = (size.width - 1.8 * circleSpacing) / 4
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
            let circle = CALayer.drawCircleLayerWith(size: CGSize(width: circleSize, height: circleSize), color: color)
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

final class AudioEqualizer {
    
    var size: CGSize
    
    init(size: CGSize) {
        self.size = size
    }
    
    func createLayer(with color: UIColor) -> CALayer? {
        let layer: CAShapeLayer? = CAShapeLayer()
        layer?.fillColor = color.cgColor
        return layer
    }
    
    func setUpAnimation(in layer: CALayer, color: UIColor) {
        
        let lineSize = (size.width * 0.05) / EqualizerConstants.lineSizeDenominator
        let xOffset = (lineSize * 9.5) / EqualizerConstants.xOffsetDenominator
        let yOffset = layer.bounds.size.height - size.height
        let x = layer.bounds.size.width - xOffset
        let y = yOffset * EqualizerConstants.yMultiplier
        
        // I hard coded these because I was looking for the best combination
        
        // MARK TODO: - Change hard coded to multiples
        
        let duration: [CFTimeInterval?] = [6, 5.5, 7.5, 9.5, 14.4, 13.5, 7.3, 6.5, 8, 9, 8.5, 6.5, 9.8, 7, 8, 5.5, 16, 8.5, 9.3, 8, 6, 15, 7.5, 8.5, 4, 13.5, 9.3, 6.5, 8, 6, 15.5, 4.5, 7.5, 5, 8, 16, 8.5, 5, 14.5, 9, 15.5, 6.3, 14.5, 8, 6, 7.5, 5, 7.5, 5, 9.5, 5, 9.5, 14, 13.5, 7, 8.5, 6, 6, 5.5, 5, 14.5, 6.4, 9.3, 5.5, 9, 6, 8.5, 5, 9.5, 6.3, 5, 7, 8.5, 9.2, 6, 5, 9.7, 5.5, 6.5, 5.5, 9.5, 6.5, 13.5, 8, 6, 9.5, 6.5, 4.5, 14, 3.5, 7.3, 8.5, 12, 6, 5.5, 5, 9.5, 7, 13.5, 3, 12.5, 8, 6, 8.5, 5, 4.5, 14, 17.5, 7.3, 5, 6, 5, 4.5, 14, 3.5, 7, 5.5, 9, 6, 15.5, 5, 4.5, 4, 9.5, 3, 12.5, 8, 6, 8.5, 5, 5, 4, 7.5, 13, 6.5, 8, 6, 8.5, 5, 4.5, 4, 9.5, 13, 12.5, 5.5, 8, 9 ,6, 5.5, 5, 4.5, 4, 9.5, 6, 12.5, 6, 5.5, 15, 4.5, 14, 3.5, 3, 7.5, 8.2, 6, 15.5, 7.5, 9.5, 14.4, 13.5, 13, 6.5, 8, 6, 5.5, 8.5, 6.8, 7, 8, 7.5, 6, 8.5, 9.3, 8, 6, 5, 7.5, 8.5, 4, 3.5, 13, 2.5, 8, 6, 8.5, 7.5, 13.5, 5, 8, 6, 8.5, 5, 8.5, 8, 5.5, 13, 4.5, 8, 6, 7.5, 5, 7.5, 5, 9.5, 5, 14.5, 9, 13.5, 3, 2.5, 2, 6, 5.5, 5, 4.5, 6.4, 13, 5.5, 15, 6, 8.5, 5, 9.5, 13, 8, 7, 8.5, 9.2, 6, 5, 9.7, 5.5, 6.5, 5.5, 13.5, 6.5, 13.5, 8, 6, 5.5, 6.5, 4.5, 4, 13.5, 3, 12.5, 12, 6, 5.5, 9, 8.5, 14, 13.5]
        
        let values = [0.01, 0.06, 0.06, 0.18, 0.2, 0.27, 0.06, 0.2 ,0.06 , 0.3, 0.0, 0.2, 0.06, 0.18, 0.3, 0.08, 0, 0.08 ,0.08 ,0.06, 0.1, 0.06, 0.06, 0.18, 0.02, 0.18, 0.3, 0.06, 0.08 ,0.15, 0.1, 0.35, 0.08, 0.26, 0.02, 0.08, 0.01, 0.06 ,0.06 ,0.18, 0.05, 0.01, 0.15, 0.08, 0.2, 0.18, 0.1, 0.08 ,0.01 ,0.14, 0.07, 0.1, 0.01, 0.18, 0.28, 0.04, 0.02, 0.01 ,0.02 ,0.02, 0.21, 0.0, 0.06, 0.18, 0.32, 0.2, 0.06, 0.2 ,0.06 , 0.01, 0.01, 0.02, 0.06, 0.18, 0.2, 0.18, 0, 0.1 ,0.1 ,0.06, 0.01, 0.06, 0.06, 0.18, 0.02, 0.08, 0.03, 0.06, 0.08 ,0.05, 0.1, 0.15, 0.08, 0.18, 0.2, 0.18, 0.01, 0.3 ,0.3 ,0.08, 0.25, 0.1, 0.15]
        
        
        for i in 0 ..< 235 {
            
            let animation = CAKeyframeAnimation()
            animation.keyPath = "path"
            animation.isAdditive = true
            animation.values = []
            
            for value in 0..<values.count {
                
                let heightFactor =  values[value]
                let heightOffset = CGFloat(heightFactor) / EqualizerConstants.heightOffsetDenominator
                let height = size.height * heightOffset
                let pointOffset =  height * EqualizerConstants.pointOffsetMultiplier
                let point = CGPoint(x: 0, y: size.height - pointOffset)
                
                let roundRect = CGRect(origin: point,
                                       size: CGSize(width: lineSize * 0.8,
                                                    height: height * 2.6))
                
                let path: UIBezierPath? =  UIBezierPath(roundedRect: roundRect,
                                                        byRoundingCorners: [],
                                                        cornerRadii: EqualizerConstants.cornerRadii)
                if let path = path {
                    animation.values?.append(path.cgPath)
                }
            }
            
            if let timeDuration = duration[i] {
                animation.duration = timeDuration * EqualizerConstants.durationMultiplier
            }
            
            animation.repeatCount = HUGE
            animation.isRemovedOnCompletion = false
            
            let line = createLayer(with: UIColor(red:0.15, green:0.99, blue:0.99, alpha:1.0))
            let xVal = x + lineSize * EqualizerConstants.xValMultiplier * CGFloat(i) * 0.5
            let yVal = y * EqualizerConstants.yValMutliplier * 0.9
            let widthVal = lineSize * EqualizerConstants.widthValMultiplier * 2
            let heightVal = size.height / EqualizerConstants.heightValMultiplier * 1.5
            let frame = CGRect(x: xVal,
                               y: yVal,
                               width: widthVal,
                               height: heightVal)
            if let line = line {
                line.frame = frame
                line.add(animation, forKey: "animation")
                layer.addSublayer(line)
            }
        }
    }
}
