//
//  AudioIndicatorView.swift
//  PodCatcher
//
//  Created by Christopher Webb on 5/12/18.
//  Copyright © 2018 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

final class AudioIndicatorView: UIView {
    
    var color: UIColor? = .gray
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
            let animation: AudioEqualizer2? = AudioEqualizer2()
            if let animation = animation {
                setUpAnimation()
            }
        }
    }
    
    func stopAnimating() {
        isHidden = true
        isAnimating = false
        layer.sublayers?.removeAll()
    }
    
    private final func setUpAnimation() {
        let animation: AnimationDelegate = animationType!
        var animationRect = UIEdgeInsetsInsetRect(frame, UIEdgeInsetsMake(padding, padding, padding, padding))
        let minEdge = min(animationRect.width, animationRect.height)
        
        layer.sublayers = nil
        animationRect.size = CGSize(width: minEdge, height: minEdge)
        animation.setUpAnimation(in: layer, size: animationRect.size, color: color!)
    }
}
