//
//  TagsView.swift
//  PodCatcher
//
//  Created by Christopher Webb-Orenstein on 1/15/18.
//  Copyright © 2018 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit
//UIOffset(horizontal: 10, vertical: 10)
func flowLayout(containerSize: CGSize, spacing: UIOffset = UIOffset(horizontal: 8, vertical: 8), sizes: [CGSize]) -> [CGRect] {
    var current = CGPoint.zero
    var lineHeight = 0 as CGFloat
    
    var result: [CGRect] = []
    for size in sizes {
        if current.x + size.width > containerSize.width {
            current.x = 0
            current.y += lineHeight + spacing.vertical
            lineHeight = 0
        }
        defer {
            lineHeight = max(lineHeight, size.height)
            current.x += size.width + spacing.horizontal
        }
        result.append(CGRect(origin: current, size: size))
    }
    return result
}

final class ButtonsView: UIView {
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let sizes = subviews.map { $0.intrinsicContentSize }
        let frames = flowLayout(containerSize: bounds.size, sizes: sizes)
        for (idx, frame) in frames.enumerated() {
            subviews[idx].frame = frame
        }
    }
}
