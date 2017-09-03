// Credit: NVActivityIndicatorView

import UIKit

struct EqualizerConstants {
    static let lineSizeDenominator: CGFloat = 20
    static let xOffsetDenominator: CGFloat =  0.043
    static let yMultiplier: CGFloat = 5.5
    static let pointOffsetMultiplier: CGFloat = 0.8
    static let heightOffsetDenominator: CGFloat = 1.9
    static let xValMultiplier: CGFloat = 1.9
    static let yValMutliplier: CGFloat = 0.45
    static let widthValMultiplier: CGFloat = 2
    static let heightValMultiplier: CGFloat = 0.1
    static let durationMultiplier: Double = 1.1
    static let cornerRadii: CGSize = CGSize(width: 0.0, height: 0.0)
}

protocol AnimatableView {
    func animate(from view: UIView, with offset: CGFloat?, completion: ((Bool) -> Void)?)
}

struct SpinAnimation: AnimatableView {
    
    fileprivate let AnimationDuration: Double = 0.2
    fileprivate let AnimationOffset: CGFloat = -40
    
    static func animate(from view: UIView, with offset: CGFloat?, completion: ((Bool) -> Void)?) {
        let animation = SpinAnimation()
        animation.animate(from: view, with: offset, completion: completion)
    }
    
    func animate(from view: UIView, with offset: CGFloat?, completion: ((Bool) -> Void)?) {
        let offset  = offset ?? AnimationOffset
        let up = CGAffineTransform(translationX: 0, y: offset + 2)
        
        let spinAnimation = UIViewPropertyAnimator(duration: AnimationDuration, dampingRatio: 0.4, animations: {
            view.transform = up
            let rotation = CABasicAnimation(keyPath: "transform.rotation")
            rotation.toValue = CGFloat(2.0 * Double.pi)
            
            rotation.duration = self.AnimationDuration + 0.25
            rotation.repeatCount = 1.0
            rotation.timingFunction = CAMediaTimingFunction(controlPoints: 0.32, 0.80, 0.18, 1.00)
            view.layer.add(rotation, forKey: "rotateStar")
        })
        
        let jumpAnimation = UIViewPropertyAnimator(duration: 0.2, curve: .linear, animations: {
            view.transform = CGAffineTransform.identity
        })
        
        let growAnimation = UIViewPropertyAnimator(duration: 0.2, curve: .linear, animations: {
            view.transform = CGAffineTransform(scaleX: -0.25, y: -0.25)
        })
        
        let shrinkAnimation = UIViewPropertyAnimator(duration: 0.5, curve: .linear, animations: {
            view.transform = CGAffineTransform(scaleX: 1, y: 1)
        })
        UIView.animate(withDuration: 0.75) {
            spinAnimation.startAnimation()
            jumpAnimation.startAnimation()
            growAnimation.startAnimation()
            shrinkAnimation.startAnimation()
        }
    }
}


class BigAnimation: AnimatableView {
    
    func animate(from view: UIView, with offset: CGFloat?, completion: ((Bool) -> Void)?) {
    }
    
    private func setupSlowAnimation(animation: CABasicAnimation) {
        animation.duration = 0.3
        animation.fromValue = 1
        animation.toValue = 2
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        animation.autoreverses = true
        animation.repeatCount = 2
    }
    
    private func animateYSlow() -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "transform.scale.y")
        setupSlowAnimation(animation: animation)
        return animation
    }
    
    private func animateXSlow() -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "transform.scale.x")
        setupSlowAnimation(animation: animation)
        return animation
    }
}


protocol AnimationDelegate {
    func setUpAnimation(in layer: CALayer, size: CGSize, color: UIColor)
}

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

final class BallIndicatorView: UIView {
    
    var color: UIColor? = .blue
    let animationType: AnimationDelegate?
    var animationRect: CGRect?
    var padding: CGFloat = 0
    
    var animating: Bool { return isAnimating }
    
    private(set) public var isAnimating: Bool = false {
        didSet {
            print("Animating \(isAnimating)")
        }
    }
    
    override init(frame: CGRect) {
        self.animationType = BallAnimation(size: CGSize(width: 0, height: 0))
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.animationType = BallAnimation(size: CGSize(width: 0, height: 0))
        super.init(coder: aDecoder)
        isHidden = true
    }
    
    init(frame: CGRect?, color: UIColor? = nil, padding: CGFloat? = nil, animationType: AnimationDelegate) {
        guard let frame = frame else { fatalError("Frame does not exist") }
        
        self.animationType = animationType
        super.init(frame: frame)
        animationRect = CGRect(x: frame.size.width,
                               y: frame.size.height,
                               width: 0,
                               height: 0)
        guard let padding = padding else { return }
        self.padding = padding
        self.color = color
        isHidden = true
    }
    
    func startAnimating() {
        isHidden = false
        isAnimating = true
        layer.speed = 1
        if let animationRect = animationRect {
            let animation: BallAnimation? = BallAnimation(size: animationRect.size)
            if let animation = animation {
                setUpAnimation(ballAnimation: animation)
            }
        }
    }
    
    func stopAnimating() {
        isHidden = true
        isAnimating = false
        layer.sublayers?.removeAll()
    }
    
    private func setUpAnimation(ballAnimation: AnimationDelegate) {
        let animationType: AnimationDelegate = ballAnimation
        var animationRect: CGRect = UIEdgeInsetsInsetRect(frame, UIEdgeInsetsMake(padding / 3, padding / 3, padding / 3, padding / 3))
        let minEdge = min(animationRect.width, animationRect.height)
        
        layer.sublayers = nil
        animationRect.size = CGSize(width: minEdge, height: minEdge)
        guard let color = color else { return }
        animationType.setUpAnimation(in: layer, size: animationRect.size, color: color)
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


final class IndicatorView: UIView {
    
    var color: UIColor? = .white
    var animationRect: CGRect?
    var animating: Bool { return isAnimating }
    
    private(set) public var isAnimating: Bool = false {
        didSet {
            print("Animating \(isAnimating)")
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        isHidden = true
    }
    
    init(frame: CGRect?, color: UIColor? = nil, padding: CGFloat? = nil) {
        super.init(frame: frame!)
        guard let frame = frame else { return }
        let animationWidth = frame.size.width * 1.8
        let animationHeight = frame.height * 1.45
        animationRect = CGRect(x: frame.size.width * 6,
                               y: frame.height * 0.2,
                               width: animationWidth,
                               height: animationHeight)
        self.color = UIColor(red:0.03, green:0.57, blue:0.82, alpha:1.0)
        isHidden = true
    }
    
    func startAnimating() {
        isHidden = false
        isAnimating = true
        layer.speed = 1
        if let animationRect = animationRect {
            let animation: AudioEqualizer? = AudioEqualizer(size: animationRect.size)
            if let animation = animation {
                setUpAnimation(animation: animation)
            }
        }
    }
    
    func stopAnimating() {
        isHidden = true
        isAnimating = false
        layer.sublayers?.removeAll()
    }
    
    func setUpAnimation(animation: AudioEqualizer?) {
        if let animationRect = animationRect {
            let minEdge: CGFloat? = max(animationRect.width, animationRect.height)
            layer.sublayers = nil
            if let minEdge  = minEdge {
                self.animationRect?.size = CGSize(width: minEdge, height: minEdge)
                if let animation = animation {
                    guard let color = color else { return }
                    animation.setUpAnimation(in: layer, color: color)
                }
            }
        }
    }
}
