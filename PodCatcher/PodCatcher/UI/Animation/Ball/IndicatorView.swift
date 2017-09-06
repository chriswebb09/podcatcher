//
//  IndicatorView.swift
//  PodCatcher
//
//  Created by Christopher Webb-Orenstein on 9/3/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

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

