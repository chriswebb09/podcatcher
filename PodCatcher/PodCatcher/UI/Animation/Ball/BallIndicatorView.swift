import UIKit

final class BallIndicatorView: UIView {
    
    var color: UIColor? = .blue
    let animationType: AnimationDelegate?
    var animationRect: CGRect?
    var padding: CGFloat = 20
    
    var animating: Bool { return isAnimating }
    
    private(set) public var isAnimating: Bool = false {
        didSet {
            print("Animating \(isAnimating)")
        }
    }
    
    override init(frame: CGRect) {
        self.animationType = BallAnimation(size: CGSize(width: 50, height: 50))
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.animationType = BallAnimation(size: CGSize(width: 50, height: 50))
        super.init(coder: aDecoder)
        isHidden = true
    }
    
    init(frame: CGRect?, color: UIColor? = nil, padding: CGFloat? = nil, animationType: AnimationDelegate) {
        guard let frame = frame else { fatalError("Frame does not exist") }
        
        self.animationType = animationType
        super.init(frame: frame)
        let animationWidth = frame.size.width * 0.5
        let animationHeight = frame.height * 0.4
        animationRect = CGRect(x: frame.size.width,
                               y: frame.size.height,
                               width: animationWidth,
                               height: animationHeight)
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
