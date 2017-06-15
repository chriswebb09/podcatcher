//
//  EmptyCastsView.swift
//  PodCatcher
//
//  Created by Christopher Webb-Orenstein on 6/14/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

struct EmptyCastsViewConstants {
    static let musicIconHeightMultiplier: CGFloat = 0.22
    static let musicIconWidthMutliplier: CGFloat = 0.28
    static let musicIconCenterYOffset: CGFloat = UIScreen.main.bounds.height * -0.16
}

class EmptyCastsView: UIView {
    
    private var infoLabel: UILabel = UILabel.setupInfoLabel(infoText: "No podcasts found...")
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = .white
        setup(infoLabel: infoLabel)
    }
    
    func configure() {
        layoutSubviews()
    }
    
    private func setup(infoLabel: UILabel) {
        addSubview(infoLabel)
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        infoLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: EmptyCastsViewConstants.musicIconWidthMutliplier).isActive = true
        infoLabel.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        infoLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        infoLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
}
