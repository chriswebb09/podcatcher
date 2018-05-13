//
//  BrowseSection.swift
//  PodCatcher
//
//  Created by Christopher Webb on 5/13/18.
//  Copyright © 2018 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

final class BrowseSection: UIView {
    
    var titleLabel: UILabel = {
        let title = UILabel()
        title.textColor = UIColor(red:0.24, green:0.24, blue:0.24, alpha:1.0)
        title.font = Style.Font.PlaylistCell.title
        title.text = "Podcasts"
        title.textAlignment = .left
        return title
    }()
    
    var goToLabel: UILabel = {
        let title = UILabel()
        title.textColor = UIColor(red:0.62, green:0.62, blue:0.62, alpha:1.0)
        title.font = Style.Font.PlaylistCell.title
        title.text = "Podcasts"
        title.textAlignment = .left
        title.numberOfLines = 0
        return title
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = UIColor(red:0.96, green:0.96, blue:0.96, alpha:1.0)
        setup(titleLabel: titleLabel)
        layer.borderWidth = 1
        layer.borderColor = UIColor.lightGray.cgColor
    }
    
    func setup(titleLabel: UILabel) {
        self.addSubview(titleLabel)
        print("here")
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 480, 960, 1136:
                if #available(iOS 11, *) {
                    titleLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
                } else {
                    titleLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
                }
                titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
                titleLabel.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.29).isActive = true
                titleLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.3).isActive = true
                titleLabel.layoutIfNeeded()
            case 1334, 2208:
                titleLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
                titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
                titleLabel.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.34).isActive = true
                titleLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.3).isActive = true
                titleLabel.layoutIfNeeded()
            default:
                titleLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
                titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
                titleLabel.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.29).isActive = true
                titleLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.3).isActive = true
                titleLabel.layoutIfNeeded()
            }
        }
    }
}
