//
//  AnimatableView .swift
//  PodCatcher
//
//  Created by Christopher Webb-Orenstein on 9/3/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

protocol AnimatableView {
    func animate(from view: UIView, with offset: CGFloat?, completion: ((Bool) -> Void)?)
}

