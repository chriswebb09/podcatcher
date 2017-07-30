// Credit: NVActivityIndicatorView

import UIKit


protocol AnimatableView {
    func animate(from view: UIView, with offset: CGFloat?, completion: ((Bool) -> Void)?)
}

class SpinAnimation: AnimatableView {
    fileprivate let AnimationDuration: Double = 0.25
    fileprivate let AnimationOffset: CGFloat = -40
    
    static func animate(from view: UIView, with offset: CGFloat?, completion: ((Bool) -> Void)?) {
        let animation = SpinAnimation()
        animation.animate(from: view, with: offset, completion: completion)
    }
    
    func animate(from view: UIView, with offset: CGFloat?, completion: ((Bool) -> Void)?) {
        let offset  = offset ?? AnimationOffset
        let offToolbar = CGAffineTransform(translationX: 0, y: offset)
        
        UIView.animate(withDuration: AnimationDuration, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 2.0, options: [], animations: { () -> Void in
            view.transform = offToolbar
            let rotation = CABasicAnimation(keyPath: "transform.rotation")
            rotation.toValue = CGFloat(2.0 * Double.pi)
            rotation.isCumulative = true
            rotation.duration = self.AnimationDuration + 0.07
            rotation.repeatCount = 1.0
            rotation.timingFunction = CAMediaTimingFunction(controlPoints: 0.32, 0.70, 0.18, 1.00)
            view.layer.add(rotation, forKey: "rotateStar")
        }, completion: { finished in
            UIView.animate(withDuration: self.AnimationDuration, delay: 0.15, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: [], animations: { finished in
                view.transform = CGAffineTransform.identity
            }, completion: completion)
        })
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
        let circleSize: CGFloat = (size.width - 2 * circleSpacing) / 4
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
