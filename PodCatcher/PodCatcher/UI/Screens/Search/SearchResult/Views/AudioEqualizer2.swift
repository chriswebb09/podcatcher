//
//  AudioEqualizer2.swift
//  PodCatcher
//
//  Created by Christopher Webb on 5/12/18.
//  Copyright © 2018 Christopher Webb-Orenstein. All rights reserved.
//

import Foundation
import UIKit

final class AudioEqualizer2: AnimationDelegate {
    
    static func layerWith(size: CGSize, color: UIColor) -> CALayer {
        let layer: CAShapeLayer = CAShapeLayer()
        var path: UIBezierPath = UIBezierPath()
        let lineWidth: CGFloat = 2
        path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: size.width, height: size.height),
                            cornerRadius: size.width / 2)
        layer.fillColor = color.cgColor
        return layer
    }
    
    
    func setUpAnimation(in layer: CALayer, size: CGSize, color: UIColor) {
        let lineSize = size.width / 9
        let x = (layer.bounds.size.width - lineSize * 7) / 2
        let y = (layer.bounds.size.height - size.height) / 2
        let duration: [CFTimeInterval] = [4.3, 2.5, 1.7, 3.1]
        let values = [0, 0.7, 0.4, 0.05, 0.95, 0.3, 0.9, 0.4, 0.15, 0.18, 0.75, 0.01]
        
        // Draw lines
        for i in 0 ..< 4 {
            let animation = CAKeyframeAnimation()
            
            animation.keyPath = "path"
            animation.isAdditive = true
            animation.values = []
            
            for j in 0 ..< values.count {
                let heightFactor = values[j]
                let height = size.height * CGFloat(heightFactor)
                let point = CGPoint(x: 0, y: size.height - height)
                let path = UIBezierPath(rect: CGRect(origin: point, size: CGSize(width: lineSize, height: height)))
                
                animation.values?.append(path.cgPath)
            }
            
            animation.duration = duration[i]
            animation.repeatCount = HUGE
            animation.isRemovedOnCompletion = false
            
            let line = AudioEqualizer2.layerWith(size: CGSize(width: lineSize, height: size.height), color: color)
            let frame = CGRect(x: x + lineSize * 2 * CGFloat(i),
                               y: y,
                               width: lineSize,
                               height: size.height)
            
            line.frame = frame
            line.add(animation, forKey: "animation")
            layer.addSublayer(line)
        }
    }
}
