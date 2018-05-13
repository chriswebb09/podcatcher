//
//  LowerModuleAnimatable.swift
//  PodCatcher
//
//  Created by Christopher Webb on 5/13/18.
//  Copyright © 2018 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

protocol ImageLayerAnimatable: class {
    
    var coverImageContainer: UIView! { get }
    var sourceView: CardPlayerSourceProtocol! { get }
    var backingImageEdgeInset: CGFloat { get }
    var imageLayerInsetForOutPosition: CGFloat { get }
    var coverImageContainerTopInset: NSLayoutConstraint! { get }
    var dismissChevron: UIButton! { get }
    var startColor: UIColor { get }
    var cardCornerRadius: CGFloat { get }
    var primaryDuration: Double { get }
    var endColor: UIColor { get }
    
    func configureImageLayerInStartPosition()
    func animateImageLayerIn()
    func animateImageLayerOut(completion: @escaping ((Bool) -> Void))
}

extension ImageLayerAnimatable where Self: UIViewController {
    func configureImageLayerInStartPosition() {
        coverImageContainer.backgroundColor = startColor
        let startInset = imageLayerInsetForOutPosition
        dismissChevron.alpha = 0
        coverImageContainer.layer.cornerRadius = 0
        coverImageContainerTopInset.constant = startInset
        view.layoutIfNeeded()
    }
    
    func animateImageLayerIn() {
        UIView.animate(withDuration: primaryDuration / 4.0) {
            self.coverImageContainer.backgroundColor = self.endColor
        }
        
        UIView.animate(withDuration: primaryDuration, delay: 0, options: [.curveEaseIn], animations: {
            self.coverImageContainerTopInset.constant = 0
            self.dismissChevron.alpha = 1
            self.coverImageContainer.layer.cornerRadius = self.cardCornerRadius
            self.view.layoutIfNeeded()
        })
    }
    
    func animateImageLayerOut(completion: @escaping ((Bool) -> Void)) {
        let endInset = imageLayerInsetForOutPosition
        
        UIView.animate(withDuration: primaryDuration / 4.0, delay: primaryDuration , options: [.curveEaseOut], animations: {
            self.coverImageContainer.backgroundColor = self.startColor
        }, completion: { finished in
            completion(finished)
        })
        
        UIView.animate(withDuration: primaryDuration, delay: 0, options: [.curveEaseOut], animations: {
            self.coverImageContainerTopInset.constant = endInset
            self.dismissChevron.alpha = 0
            self.coverImageContainer.layer.cornerRadius = 0
            self.view.layoutIfNeeded()
        })
    }
}


import UIKit

protocol LowerModuleAnimatable: class {
    var lowerModuleTopConstraint: NSLayoutConstraint! { get set }
    var coverArtImage: UIImageView! { get set }
    var lowerModuleInsetForOutPosition: CGFloat { get }
    var primaryDuration: Double { get }
}

extension LowerModuleAnimatable where Self: UIViewController {
    func configureLowerModuleInStartPosition() {
        lowerModuleTopConstraint.constant = lowerModuleInsetForOutPosition
    }
    
    func animateLowerModule(isPresenting: Bool) {
        let topInset = isPresenting ? 0 : lowerModuleInsetForOutPosition
        UIView.animate(withDuration: primaryDuration , delay: 0 , options: [.curveEaseIn], animations: {
            self.lowerModuleTopConstraint.constant = topInset + 40
            self.view.layoutIfNeeded()
        })
    }
    
    func animateLowerModuleOut() {
        self.coverArtImage.layer.shadowColor = UIColor.clear.cgColor
        animateLowerModule(isPresenting: false)
    }
    
    func animateLowerModuleIn() {
        self.coverArtImage.layer.shadowColor = UIColor.clear.cgColor
        animateLowerModule(isPresenting: true)
        self.coverArtImage.layer.shadowColor = UIColor.black.cgColor
    }
}
