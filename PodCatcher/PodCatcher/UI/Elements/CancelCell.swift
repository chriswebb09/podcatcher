//
//  CancelCell.swift
//  Podcatch
//
//  Created by Christopher Webb-Orenstein on 2/18/18.
//  Copyright © 2018 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

class CancelCell: UITableViewCell, BaseTitleCell {
    
    static let reuseIdentifier = "CancelCell"
    
    var titleLabel: UILabel! = UILabel()
    
    var modelName = "" {
        didSet {
            titleLabel.text = modelName.capitalized
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setup()
    }
    
    func setup() {
        setup(titleLabel: titleLabel)
        backgroundColor = .red
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
    }
    
    func setup(titleLabel: UILabel) {
        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        if #available(iOS 11, *) {
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        } else {
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: contentView.bounds.width * 0.13).isActive = true
        }
        
        titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        titleLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.18).isActive = true
        titleLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.6).isActive = true
    }
    
    func configure(with title: String) {
        titleLabel.text = title
    }
}
