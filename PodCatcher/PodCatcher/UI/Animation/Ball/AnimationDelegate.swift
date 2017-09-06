//
//  AnimationDelegate.swift
//  PodCatcher
//
//  Created by Christopher Webb-Orenstein on 9/3/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

protocol AnimationDelegate {
    func setUpAnimation(in layer: CALayer, size: CGSize, color: UIColor)
}
