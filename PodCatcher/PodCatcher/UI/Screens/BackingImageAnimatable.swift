//
//  BackingImageAnimatable.swift
//  Pods-PodCatcher
//
//  Created by Christopher Webb on 5/13/18.
//

import UIKit

protocol BackingImageAnimatable: class {
    
    var backingImage: UIImage? { get set }
    
    var backingImageView: UIImageView! { get set }
    var dimmerLayer: UIView! { get set }
    var backingImageEdgeInset: CGFloat { get set }
    var backingImageTopInset: NSLayoutConstraint! { get set }
    var backingImageLeadingInset: NSLayoutConstraint! { get set }
    var backingImageTrailingInset: NSLayoutConstraint! { get set }
    var backingImageBottomInset: NSLayoutConstraint! { get set }
    var cardCornerRadius: CGFloat { get }
    var endBackingImage: UIImage? { get }
    var primaryDuration: Double { get }
}

extension BackingImageAnimatable where Self: UIViewController {
    func configureBackingImageInPosition(presenting: Bool) {
        let edgeInset: CGFloat = presenting ? backingImageEdgeInset: 0
        let dimmerAlpha: CGFloat = presenting ? 0.3: 0
        let cornerRadius: CGFloat = presenting ? cardCornerRadius: 0
        
        backingImageLeadingInset.constant = edgeInset
        backingImageTrailingInset.constant = edgeInset
        let aspectRatio = backingImageView.frame.height / backingImageView.frame.width
        backingImageTopInset.constant = edgeInset * aspectRatio
        backingImageBottomInset.constant = edgeInset * aspectRatio
        dimmerLayer.alpha = dimmerAlpha
        backingImageView.layer.cornerRadius = cornerRadius
    }
    
    func animateBackingImage(presenting: Bool) {
        UIView.animate(withDuration: primaryDuration) {
            self.configureBackingImageInPosition(presenting: presenting)
            self.view.layoutIfNeeded() //IMPORTANT!
        }
    }
    
    func animateBackingImageIn() {
        animateBackingImage(presenting: true)
    }
    
    func animateBackingImageOut() {
        animateBackingImage(presenting: false)
    }
}
