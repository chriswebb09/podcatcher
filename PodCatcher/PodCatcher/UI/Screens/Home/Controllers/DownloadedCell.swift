//
//  DownloadedCell.swift
//  PodCatcher
//
//  Created by Christopher Webb-Orenstein on 1/15/18.
//  Copyright © 2018 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

final class DownloadedCell: UITableViewCell, Reusable {
    
    static let reuseIdentifier = "DownloadedCell"
    
    private var albumArtView: UIImageView = {
        var album = UIImageView()
        album.layer.cornerRadius = 5
        return album
    }()
    
    private var titleLabel: UILabel = {
        let title = UILabel()
        title.textColor = .gray
        title.font = UIFont(name: "AvenirNext-Regular", size: 11)
        title.textAlignment = .left
        title.numberOfLines = 0
        return title
    }()
    
    var moreButton: UIButton = {
        var more = UIButton()
        let image = #imageLiteral(resourceName: "more-icon").withRenderingMode(.alwaysTemplate)
        more.setImage(image, for: .normal)
        more.tintColor = .gray
        return more
    }()
    
    
    private var separatorView: UIView = {
        let separatorView = UIView()
        separatorView.backgroundColor = .lightGray
        return separatorView
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setup(titleLabel: titleLabel)
        setup(albumArtView: albumArtView)
        buttonConstraint(button: moreButton)
        setupSeparator()
        selectionStyle = .none
    }
    
    func configureCell(with image: UIImage?, title: String) {
        titleLabel.text = title
        if let image = image {
            albumArtView.image = image
        } else {
            albumArtView.image = #imageLiteral(resourceName: "placeholder")
        }
    }
    
    private func setupSeparator() {
        setup(separatorView: separatorView)
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.albumArtView.layer.cornerRadius = 4
            let containerLayer = CALayer()
            containerLayer.shadowColor = UIColor.darkText.cgColor
            containerLayer.shadowRadius = 1
            containerLayer.shadowOffset = CGSize(width: 0, height: 0)
            containerLayer.shadowOpacity = 0.7
            strongSelf.albumArtView.layer.masksToBounds = true
            containerLayer.addSublayer(strongSelf.albumArtView.layer)
            strongSelf.layer.addSublayer(containerLayer)
        }
    }
    
    private func setupShadow() {
        let shadowOffset = CGSize(width:-0.45, height: 0.2)
        let shadowRadius: CGFloat = 1.0
        let shadowOpacity: Float = 0.3
        contentView.layer.shadowRadius = shadowRadius
        contentView.layer.shadowOffset = shadowOffset
        contentView.layer.shadowOpacity = shadowOpacity
    }
    
    private func setup(separatorView: UIView) {
        contentView.addSubview(separatorView)
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            separatorView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.009),
            separatorView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            separatorView.rightAnchor.constraint(equalTo: rightAnchor),
            separatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
            ])
    }
    
    private func setup(titleLabel: UILabel) {
        contentView.addSubview(albumArtView)
        albumArtView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.leftAnchor.constraint(equalTo: albumArtView.rightAnchor, constant: contentView.frame.width * 0.07),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor),
            titleLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.46)
            ])
    }
    
    private func setup(albumArtView: UIImageView) {
        NSLayoutConstraint.activate([
            albumArtView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: contentView.bounds.width * 0.07),
            albumArtView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            albumArtView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.7),
            albumArtView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.15)
            ])
    }
    
    func buttonConstraint(button: UIButton) {
        contentView.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 11, *) {
            NSLayoutConstraint.activate([
                button.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.06),
                button.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.3),
                button.centerXAnchor.constraint(equalTo: centerXAnchor, constant: contentView.bounds.width * 0.34)
                ])
        } else {
            NSLayoutConstraint.activate([
                button.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.095),
                button.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.49),
                button.centerXAnchor.constraint(equalTo: centerXAnchor, constant: contentView.bounds.width * 0.42)
                ])
        }
        NSLayoutConstraint.activate([
            button.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
            ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        albumArtView.image = nil
    }
}
