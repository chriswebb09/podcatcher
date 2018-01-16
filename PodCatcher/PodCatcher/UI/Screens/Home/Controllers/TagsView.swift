//
//  TagsView.swift
//  PodCatcher
//
//  Created by Christopher Webb-Orenstein on 1/15/18.
//  Copyright © 2018 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

func justifiedFlowLayout(containerSize: CGSize, spacing: UIOffset, sizes: [CGSize]) -> [CGRect] {
    var lines: [[CGSize]] = [[]]
    for element in sizes {
        let lastline = lines.last!
        let projectedWidth = lastline.width(spacing: spacing.horizontal) + element.width + spacing.horizontal
        if projectedWidth > containerSize.width && !lastline.isEmpty {
            lines.append([])
        }
        lines[lines.endIndex-1].append(element)
    }
    var result: [CGRect] = []
    var current: CGPoint = .zero
    for line in lines {
        let width = line.width(spacing: 0)
        let actualSpacing = (containerSize.width - width) / CGFloat(line.count - 1)
        for element in line {
            result.append(CGRect(origin: current, size: element).integral)
            current.x += element.width + actualSpacing
        }
        
        current.y += line.height + spacing.vertical
        current.x = 0
    }
    return result
}
    
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
        let spacing = UIOffset(horizontal: 10, vertical: 10)
        let frames = justifiedFlowLayout(containerSize: bounds.size, spacing: spacing, sizes: sizes)
        for (idx, frame) in frames.enumerated() {
            subviews[idx].frame = frame
        }
    }
}
