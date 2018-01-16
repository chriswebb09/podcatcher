//
//  SliderView.swift
//  PodCatcher
//
//  Created by Christopher Webb-Orenstein on 1/11/18.
//  Copyright © 2018 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

class SliderView: UIView {
    
    let sliderMaskView = UIView()
    
    var cornerRadius: CGFloat! {
        didSet {
            layer.cornerRadius = cornerRadius
            sliderMaskView.layer.cornerRadius = cornerRadius
        }
    }
    
    override var frame: CGRect {
        didSet {
            sliderMaskView.frame = frame
        }
    }
    
    override var center: CGPoint {
        didSet {
            sliderMaskView.center = center
        }
    }
    
    init() {
        super.init(frame: .zero)
        layer.masksToBounds = true
        sliderMaskView.backgroundColor = .black
        sliderMaskView.layer.setShadow(for: .black)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
