//
//  DownloadedCell.swift
//  PodCatcher
//
//  Created by Christopher Webb on 5/13/18.
//  Copyright © 2018 Christopher Webb-Orenstein. All rights reserved.
//

import Foundation

import Foundation
import UIKit


final class DownloadedCell: UITableViewCell, Reusable {
    
    enum DownloadCellMode {
        case play, pause, stop, none
    }
    
    private var viewModel: DownloadedCellViewModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            titleLabel.text = viewModel.episodeName
            albumArtView.image = viewModel.podcastImage
            currentState = viewModel.currentState
        }
    }
    
    var currentState: AudioState = .stopped {
        didSet {
            switch currentState {
            case .playing:
                DispatchQueue.main.async {
                    self.playButton.isHidden = true
                    self.playButton.alpha = 0
                    self.pauseButton.isHidden = false
                    self.pauseButton.alpha = 1
                    
                }
            case .paused:
                DispatchQueue.main.async {
                    self.playButton.alpha = 1
                    self.playButton.isHidden = false
                    self.pauseButton.isHidden = true
                    self.pauseButton.alpha = 0
                }
            case .stopped:
                DispatchQueue.main.async {
                    self.pauseButton.isHidden = true
                    self.pauseButton.alpha = 0
                    self.playButton.alpha = 1
                    self.playButton.isHidden = false
                    // self.episodeTitle.text = "Not Playling"
                }
            }
        }
    }
    
    var playButton: UIButton = {
        var more = UIButton()
        let image = #imageLiteral(resourceName: "play").withRenderingMode(.alwaysTemplate)
        more.setImage(image, for: .normal)
        more.tintColor = .gray
        return more
    }()
    
    var pauseButton: UIButton! = {
        var more = UIButton()
        let image = #imageLiteral(resourceName: "pause-round").withRenderingMode(.alwaysTemplate)
        more.setImage(image, for: .normal)
        more.tintColor = .gray
        return more
    }()
    
    @objc func audio() {
        
        currentState = .playing
        DispatchQueue.main.async {
            self.playButton.isHidden = true
            self.playButton.alpha = 0
            self.pauseButton.isHidden = false
            self.pauseButton.alpha = 1
        }
        // delegate?.playButton(tapped: true)
    }
    
    
    func configureWith(model: DownloadedCellViewModel) {
        self.viewModel = model
    }
    
    weak var delegate: DownloadCellDelegate?
    
    static let reuseIdentifier = "DownloadedCell"
    
    private var albumArtView: UIImageView = {
        var album = UIImageView()
        album.layer.cornerRadius = 5
        return album
    }()
    
    private var titleLabel: UILabel = {
        let title = UILabel()
        title.textColor = .gray
        title.font = UIFont.systemFont(ofSize: 11, weight: .regular)
        
        title.textAlignment = .left
        title.numberOfLines = 0
        return title
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
        buttonConstraint(button: playButton)
        buttonConstraint(button: pauseButton)
        pauseButton.isHidden = true
        setupSeparator()
        selectionStyle = .none
        playButton.addTarget(self, action: #selector(play), for: .touchUpInside)
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
    
    
    @objc func pause() {
        currentState = .paused
        playButton.isHidden = false
        playButton.alpha = 1
        pauseButton.isHidden = true
        pauseButton.alpha = 0
        delegate?.pauseButton(tapped: true)
    }
    
    private func setup(separatorView: UIView) {
        contentView.addSubview(separatorView)
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        separatorView.rightAnchor.constrainEqual(rightAnchor)
        separatorView.widthAnchor.constrainEqual(contentView.widthAnchor)
        separatorView.bottomAnchor.constrainEqual(contentView.bottomAnchor)
        NSLayoutConstraint.activate([
            separatorView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.009),
            ])
    }
    
    private func setup(titleLabel: UILabel) {
        contentView.addSubview(albumArtView)
        albumArtView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerYAnchor.constrainEqual(contentView.centerYAnchor)
        titleLabel.heightAnchor.constrainEqual(contentView.heightAnchor)
        NSLayoutConstraint.activate([
            titleLabel.leftAnchor.constraint(equalTo: albumArtView.rightAnchor, constant: contentView.frame.width * 0.05),
            titleLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.59)
            ])
    }
    
    private func setup(albumArtView: UIImageView) {
        albumArtView.centerYAnchor.constrainEqual(contentView.centerYAnchor)
        NSLayoutConstraint.activate([
            albumArtView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: contentView.bounds.width * 0.04),
            albumArtView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.7),
            albumArtView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.15)
            ])
    }
    
    func buttonConstraint(button: UIButton) {
        contentView.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 11, *) {
            NSLayoutConstraint.activate([
                button.widthAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.5),
                button.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.5),
                button.centerXAnchor.constraint(equalTo: centerXAnchor, constant: contentView.bounds.width * 0.42)
                ])
        } else {
            NSLayoutConstraint.activate([
                button.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.095),
                button.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.49),
                button.centerXAnchor.constraint(equalTo: centerXAnchor, constant: contentView.bounds.width * 0.42)
                ])
        }
        button.centerYAnchor.constrainEqual(contentView.centerYAnchor)
    }
    
    @objc func play() {
        audio()
        delegate?.moreButtonTapped(sender: playButton, cell: self)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        albumArtView.image = nil
    }
}
