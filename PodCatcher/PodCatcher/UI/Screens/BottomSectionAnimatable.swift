//
//  BottomSectionAnimatable.swift
//  PodCatcher
//
//  Created by Christopher Webb on 5/13/18.
//  Copyright © 2018 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

protocol BottomSectionAnimatable: class {
    var tabBarImage: UIImage? { get set }
    var bottomSectionImageView: UIImageView! { get }
    var bottomSectionHeight: NSLayoutConstraint! { get }
    var bottomSectionLowerConstraint: NSLayoutConstraint! { get }
    var primaryDuration: Double { get }
}

extension BottomSectionAnimatable where Self: UIViewController {
    func configureBottomSection() {
        if let image = tabBarImage {
            bottomSectionHeight.constant = image.size.height
           
            bottomSectionImageView.image = image
        } else {
            bottomSectionHeight.constant = 0
        }
        view.layoutIfNeeded()
    }
    
    func animateBottomSectionOut() {
        if let image = tabBarImage {
            UIView.animate(withDuration: primaryDuration / 2.0) {
                self.bottomSectionLowerConstraint.constant = -image.size.height
                self.view.layoutIfNeeded()
            }
        }
    }
    
    func animateBottomSectionIn() {
        if tabBarImage != nil {
            UIView.animate(withDuration: primaryDuration / 2.0) {
                self.bottomSectionLowerConstraint.constant = 0
                self.view.layoutIfNeeded()
            }
        }
    }
}
