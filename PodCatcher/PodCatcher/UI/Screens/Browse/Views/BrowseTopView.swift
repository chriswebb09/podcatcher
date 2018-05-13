import UIKit

//
//  BrowseTopView.swift
//  Podcatch
//
//  Created by Christopher Webb-Orenstein on 2/3/18.
//  Copyright © 2018 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

final class BrowseTopView: UIView, BaseView {
    
    var index: Int = 0
    
    // MARK: - UI Properties
    
    var titleLabel: UILabel = {
        let title = UILabel()
        title.textColor = .white
        title.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        title.textAlignment = .center
        title.numberOfLines = 0
        return title
    }()
    
    var podcastImageView: UIImageView! = {
        var podcastImageView = UIImageView()
        podcastImageView.layer.setCellShadow(contentView: podcastImageView)
        podcastImageView.layer.cornerRadius = 2
        return podcastImageView
    }()
    
    var background = UIView()
    
    var podcastTitleLabel: UILabel! = {
        var podcastTitle = UILabel()
        podcastTitle.textAlignment = .center
        return podcastTitle
    }()
    
    var overlayView: UIView = {
        let overlay = UIView()
        overlay.backgroundColor = .black
        overlay.alpha = 0.3
        return overlay
    }()
    
    var dataView: UIView = {
        var dataView = UIView()
        dataView.backgroundColor = .clear
        return dataView
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        add(dataView)
        addSubview(background)
        background.frame = frame
        sendSubview(toBack: background)
        setup()
        bringSubview(toFront: overlayView)
        layer.setCellShadow(contentView: self)
        layoutIfNeeded()
        background.backgroundColor = UIColor(red:0.19, green:0.23, blue:0.26, alpha:1.0)
    }
    
    func setup() {
        setup(podcastImageView: podcastImageView)
        setup(dataView: dataView)
        setup(overlayView: overlayView)
        setup(titleLabel: titleLabel)
        
    }
    
    func setup(podcastImageView: UIImageView) {
        addSubview(podcastImageView)
        podcastImageView.translatesAutoresizingMaskIntoConstraints = false
        podcastImageView.centerXAnchor.constrainEqual(centerXAnchor)
        
        if #available(iOS 11, *) {
            podcastImageView.centerYAnchor.constrainEqual(centerYAnchor)
            
            NSLayoutConstraint.activate([
                podcastImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.9),
                podcastImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.6)
                ])
        } else {
            NSLayoutConstraint.activate([
                podcastImageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: BrowseListTopViewConstants.imageCenterYOffset),
                podcastImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: BrowseListTopViewConstants.imageHeightMultiplier),
                podcastImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: BrowseListTopViewConstants.imageWidthMultiplier)
                ])
            podcastImageView.layoutIfNeeded()
            layoutIfNeeded()
        }
    }
    
    func setup(dataView: UIView) {
        add(dataView)
        dataView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dataView.topAnchor.constraint(equalTo: topAnchor),
            dataView.widthAnchor.constraint(equalTo: widthAnchor),
            dataView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 1)
            ])
    }
    
    func setup(overlayView: UIView) {
        dataView.add(overlayView)
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        overlayView.topAnchor.constrainEqual(dataView.topAnchor)
        overlayView.widthAnchor.constrainEqual(dataView.widthAnchor)
        overlayView.heightAnchor.constrainEqual(dataView.heightAnchor)
    }
    
    func setup(titleLabel: UILabel) {
        dataView.add(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.widthAnchor.constrainEqual(dataView.widthAnchor)
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 480, 960:
                NSLayoutConstraint.activate([
                    titleLabel.heightAnchor.constraint(equalTo: dataView.heightAnchor, multiplier: 0.3)
                    ])
            case 1136, 1334, 2208:
                NSLayoutConstraint.activate([
                    titleLabel.heightAnchor.constraint(equalTo: dataView.heightAnchor, multiplier: 0.4)
                    ])
            default:
                break
            }
            titleLabel.centerXAnchor.constrainEqual(dataView.centerXAnchor)
            titleLabel.centerYAnchor.constrainEqual(dataView.centerYAnchor)
        }
    }
    
    func setTitle(title: String) {
        titleLabel.text = title
    }
}


//final class BrowseTopView: UIView {
//
//    var index: Int = 0
//
//    weak var delegate: TopViewDelegate?
//
//    // MARK: - UI Properties
//
//    let sliderBarView = UIView()
//    var sliderControl = SliderControl()
//
//
//    var titleLabel: UILabel = {
//        let title = UILabel()
//        title.textColor = .white
//
//        title.font = UIFont(name: "AvenirNext-DemiBold", size: 24)
//
//        title.textAlignment = .center
//        title.numberOfLines = 0
//        return title
//    }()
//
//    var podcastImageView: UIImageView! = {
//        var podcastImageView = UIImageView()
//        podcastImageView.layer.setCellShadow(contentView: podcastImageView)
//        podcastImageView.layer.cornerRadius = 2
//        return podcastImageView
//    }()
//
//    var background = UIView()
//
//    var podcastTitleLabel: UILabel! = {
//        var podcastTitle = UILabel()
//        podcastTitle.textAlignment = .center
//        return podcastTitle
//    }()
//
//    var overlayView: UIView = {
//        let overlay = UIView()
//        overlay.backgroundColor = .black
//        overlay.alpha = 0.3
//        return overlay
//    }()
//
//    var dataView: UIView = {
//        var dataView = UIView()
//        dataView.backgroundColor = .clear
//        return dataView
//    }()
//
//    var preferencesView: PreferencesView = {
//        var preferencesView = PreferencesView()
//        preferencesView.layoutSubviews()
//        return preferencesView
//    }()
//
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        add(dataView)
//        addSubview(background)
//        background.frame = frame
//        sendSubview(toBack: background)
//        setupConstraints()
//        bringSubview(toFront: overlayView)
//        layer.setCellShadow(contentView: self)
//        layoutIfNeeded()
//
//        background.backgroundColor = UIColor(red:0.19, green:0.23, blue:0.26, alpha:1.0)
//    }
//
//    func setupConstraints() {
//        setup(podcastImageView: podcastImageView)
//
//        setup(dataView: dataView)
//        setup(overlayView: overlayView)
//        setup(titleLabel: titleLabel)
//        setup(titleLabel: podcastTitleLabel)
//        preferencesView.layoutSubviews()
//    }
//
//    func setup(podcastImageView: UIImageView) {
//        addSubview(podcastImageView)
//        podcastImageView.translatesAutoresizingMaskIntoConstraints = false
//        if #available(iOS 11, *) {
//            NSLayoutConstraint.activate([
//                podcastImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
//                podcastImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
//                podcastImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.9),
//                podcastImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.6)
//                ])
//        } else {
//            NSLayoutConstraint.activate([
//                podcastImageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: BrowseListTopViewConstants.podcastImageViewCenterYOffset),
//                podcastImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
//                podcastImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: BrowseListTopViewConstants.podcastImageViewHeightMultiplier),
//                podcastImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: BrowseListTopViewConstants.podcastImageViewWidthMultiplier)
//                ])
//            podcastImageView.layoutIfNeeded()
//            layoutIfNeeded()
//        }
//    }
//
//    func setup(dataView: UIView) {
//        add(dataView)
//        dataView.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            dataView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
//            dataView.widthAnchor.constraint(equalTo: widthAnchor),
//            dataView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 1)
//            ])
//    }
//
//    func setup(overlayView: UIView) {
//        dataView.add(overlayView)
//        overlayView.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            overlayView.topAnchor.constraint(equalTo: dataView.topAnchor, constant: 0),
//            overlayView.widthAnchor.constraint(equalTo: dataView.widthAnchor),
//            overlayView.heightAnchor.constraint(equalTo: dataView.heightAnchor, multiplier: 1)
//            ])
//    }
//
//    func setup(titleLabel: UILabel) {
//        dataView.add(titleLabel)
//        titleLabel.translatesAutoresizingMaskIntoConstraints = false
//
//
//        if UIDevice().userInterfaceIdiom == .phone {
//            switch UIScreen.main.nativeBounds.height {
//            case 480, 960:
//                NSLayoutConstraint.activate([
//                    titleLabel.centerXAnchor.constraint(equalTo: dataView.centerXAnchor, constant: 0),
//                    titleLabel.widthAnchor.constraint(equalTo: dataView.widthAnchor),
//                    titleLabel.centerYAnchor.constraint(equalTo: dataView.centerYAnchor),
//                    titleLabel.heightAnchor.constraint(equalTo: dataView.heightAnchor, multiplier: 0.3)
//                    ])
//            case 1136, 1334:
//                NSLayoutConstraint.activate([
//                    titleLabel.centerXAnchor.constraint(equalTo: dataView.centerXAnchor, constant: 0),
//                    titleLabel.widthAnchor.constraint(equalTo: dataView.widthAnchor),
//                    titleLabel.centerYAnchor.constraint(equalTo: dataView.centerYAnchor),
//                    titleLabel.heightAnchor.constraint(equalTo: dataView.heightAnchor, multiplier: 0.4)
//                    ])
//            case 2208:
//                NSLayoutConstraint.activate([
//                    titleLabel.centerXAnchor.constraint(equalTo: dataView.centerXAnchor, constant: 0),
//                    titleLabel.widthAnchor.constraint(equalTo: dataView.widthAnchor),
//                    titleLabel.centerYAnchor.constraint(equalTo: dataView.centerYAnchor),
//                    titleLabel.heightAnchor.constraint(equalTo: dataView.heightAnchor, multiplier: 0.3)
//                    ])
//
//            default:
//                NSLayoutConstraint.activate([
//                    titleLabel.centerXAnchor.constraint(equalTo: dataView.centerXAnchor, constant: 0),
//                    titleLabel.widthAnchor.constraint(equalTo: dataView.widthAnchor),
//                    titleLabel.centerYAnchor.constraint(equalTo: dataView.centerYAnchor),
//                    titleLabel.heightAnchor.constraint(equalTo: dataView.heightAnchor, multiplier: 0.3)
//                    ])
//            }
//        }
//    }
//
//    func setTitle(title: String) {
//        self.titleLabel.text = title
//    }
//}
