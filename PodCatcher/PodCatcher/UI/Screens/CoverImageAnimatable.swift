//
//  CoverImageAnimatable.swift
//  PodCatcher
//
//  Created by Christopher Webb on 5/13/18.
//  Copyright © 2018 Christopher Webb-Orenstein. All rights reserved.
//


import UIKit

protocol CoverImageAnimatable: class {
    var coverImageContainer: UIView! { get set }
    var coverArtImage: UIImageView! { get set }
    var coverImageLeading: NSLayoutConstraint! { get set }
    var coverImageTop: NSLayoutConstraint! { get set }
    var coverImageBottom: NSLayoutConstraint! { get set }
    var coverImageHeight: NSLayoutConstraint! { get set }
    var coverImageContainerTopInset: NSLayoutConstraint! { get set }
    var sourceView: CardPlayerSourceProtocol! { get }
    var primaryDuration: Double { get }
    
    func configureCoverImageInStartPosition()
    func animateCoverImageIn()
    func animateCoverImageOut()
}

extension CoverImageAnimatable where Self: UIViewController {
    
    func configureCoverImageInStartPosition() {
        let originatingImageFrame = sourceView.originatingCoverImageView.frame
        coverImageHeight.constant = originatingImageFrame.height
        coverImageLeading.constant = originatingImageFrame.minX
        coverImageTop.constant = originatingImageFrame.minY
        coverImageBottom.constant = originatingImageFrame.minY
    }
    
    func animateCoverImageIn() {
        let coverImageEdgeContraint: CGFloat = 50
        
        let endHeight = coverImageContainer.bounds.width - coverImageEdgeContraint * 2
        UIView.animate(withDuration: primaryDuration, delay: 0, options: [.curveEaseIn], animations: {
            self.coverImageHeight.constant = endHeight
            self.coverImageLeading.constant = coverImageEdgeContraint - 5
            self.coverImageTop.constant = coverImageEdgeContraint
            self.coverImageBottom.constant = coverImageEdgeContraint
            self.view.layoutIfNeeded()
        })
    }
    
    func animateCoverImageOut() {
        UIView.animate(withDuration: primaryDuration, delay: 0, options: [.curveEaseOut], animations: {
            self.configureCoverImageInStartPosition()
            self.view.layoutIfNeeded()
        })
    }
}
