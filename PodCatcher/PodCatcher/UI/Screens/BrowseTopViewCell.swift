//
//  BrowseTopViewCell.swift
//  PodCatcher
//
//  Created by Christopher Webb on 5/13/18.
//  Copyright © 2018 Christopher Webb-Orenstein. All rights reserved.
//

import Foundation
import UIKit

final class BrowseTopViewCell: UICollectionViewCell {
    
    var index: Int = 0
    
    // MARK: - UI Properties
    
    var podcast: Podcast!
    
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
        podcastImageView.layer.cornerRadius = 8
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
    
    private struct InternalConstants {
        static let alphaSmallestValue: CGFloat = 0.85
        static let scaleDivisor: CGFloat = 10.0
    }
    
    var dataView: UIView = {
        var dataView = UIView()
        dataView.backgroundColor = .clear
        return dataView
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        sendSubview(toBack: background)
        setupConstraints()
        layer.setCellShadow(contentView: self)
        layoutIfNeeded()
        clipsToBounds = false
        layer.cornerRadius = 9
        podcastImageView.layer.cornerRadius = 6
        background.backgroundColor = UIColor(red:0.19, green:0.23, blue:0.26, alpha:1.0)
    }
    
    func setBackground() {
        let background = UIImageView()
        background.image = podcastImageView.image
        background.frame = CGRect(x: frame.minX, y: frame.minY - 2, width: frame.width, height: frame.height)
        add(background)
        background.addBlurEffect()
        bringSubview(toFront: podcastImageView)
        background.alpha = 0.6
    }
    
    func setupConstraints() {
        setup(podcastImageView: podcastImageView)
        setup(titleLabel: titleLabel)
    }
    
    func setup(podcastImageView: UIImageView) {
        addSubview(podcastImageView)
        podcastImageView.translatesAutoresizingMaskIntoConstraints = false
        podcastImageView.centerXAnchor.constraint(equalTo: centerXAnchor)
        if #available(iOS 11, *) {
            NSLayoutConstraint.activate([
                podcastImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
                podcastImageView.heightAnchor.constraint(equalTo: heightAnchor),
                podcastImageView.widthAnchor.constraint(equalTo: widthAnchor)
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
            dataView.heightAnchor.constraint(equalTo: heightAnchor)
            ])
    }
    
    func setup(overlayView: UIView) {
        dataView.add(overlayView)
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            overlayView.topAnchor.constraint(equalTo: dataView.topAnchor),
            overlayView.widthAnchor.constraint(equalTo: dataView.widthAnchor),
            overlayView.heightAnchor.constraint(equalTo: dataView.heightAnchor)
            ])
    }
    
    func setup(titleLabel: UILabel) {
        dataView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
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
            NSLayoutConstraint.activate([
                titleLabel.centerXAnchor.constraint(equalTo: dataView.centerXAnchor),
                titleLabel.widthAnchor.constraint(equalTo: dataView.widthAnchor),
                titleLabel.centerYAnchor.constraint(equalTo: dataView.centerYAnchor)
                ])
        }
    }
    
    func setTitle(title: String) {
        titleLabel.text = title
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}
