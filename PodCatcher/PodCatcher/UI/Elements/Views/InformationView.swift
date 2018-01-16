//
//  InformationView.swift
//  PodCatcher
//
//  Created by Christopher Webb-Orenstein on 1/12/18.
//  Copyright © 2018 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

class InformationView: UIView, StateView {
    
    var stateData: String {
        didSet {
            DispatchQueue.main.async {
                self.setLabel(text: self.stateData)
            }
        }
    }
    
    var stateImage: UIImage {
        didSet {
            DispatchQueue.main.async {
                self.setIcon(icon: self.stateImage)
            }
        }
    }
    
    var informationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AvenirNext-DemiBold", size: 12)
        // UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.medium)
        label.textColor = UIColor(red:0.38, green:0.63, blue:0.80, alpha:1.0)
            //UIColor(red:0.40, green:0.73, blue:0.96, alpha:1.0)
            //Style.Color.Highlight.brightHighlight
        //Colors.brightHighlight
        label.alpha = 1
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = label.text?.uppercased()
        return label
    }()
    
    private var backgroundImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "whitebackground")
        imageView.alpha = 0.8
        return imageView
    }()
    
    var iconView: UIImageView = {
        var icon = UIImageView()
        return icon
    }()
    
    init(data: String, icon: UIImage) {
        self.stateData = data
        self.stateImage = icon
        super.init(frame: CGRect.zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = .white
        //UIColor(red:0.32, green:0.13, blue:0.70, alpha:1.0)
        setup(icon: iconView)
        setup(infoLabel: informationLabel)
        addSubview(backgroundImageView)
    }
    
    func configure() {
        layoutSubviews()
    }
    
    private func setup(icon: UIView) {
        addSubview(icon)
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.22).isActive = true
        icon.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.38).isActive = true
        icon.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        icon.centerYAnchor.constraint(equalTo: centerYAnchor, constant: UIScreen.main.bounds.height * -0.1).isActive = true
    }
    
    func setIcon(icon: UIImage) {
        iconView.image = icon
        iconView.image  = icon.withRenderingMode(.alwaysTemplate)
        iconView.tintColor = UIColor(red:0.38, green:0.63, blue:0.80, alpha:1.0)
            //UIColor(red:0.33, green:0.33, blue:1.00, alpha:1.0)
            //UIColor(red:0.37, green:0.67, blue:0.89, alpha:1.0)
            //UIColor(red:0.40, green:0.73, blue:0.96, alpha:1.0)
        iconView.alpha = 1
    }
    
    func setLabel(text: String) {
        informationLabel.text = text
        informationLabel.font = UIFont(name: "AvenirNext-Regular", size: 18)!
            //UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.medium)
        informationLabel.textColor = UIColor(red:0.38, green:0.63, blue:0.80, alpha:1.0)
            //UIColor(red:0.33, green:0.33, blue:1.00, alpha:1.0)
            //UIColor(red:0.37, green:0.67, blue:0.89, alpha:1.0)
            //UIColor(red:0.40, green:0.73, blue:0.96, alpha:1.0)
            //Style.Color.Highlight.brightHighlight
        //Colors.brightHighlight
        informationLabel.alpha = 1
        informationLabel.numberOfLines = 0
        informationLabel.textAlignment = .center
    
    }
    
    private func setup(infoLabel: UILabel) {
        addSubview(infoLabel)
        //UIColor(red:0.40, green:0.73, blue:0.96, alpha:1.0)
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        infoLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.3).isActive = true
        infoLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.98).isActive = true
        infoLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        infoLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: UIScreen.main.bounds.height * 0.1).isActive = true
    }
}
