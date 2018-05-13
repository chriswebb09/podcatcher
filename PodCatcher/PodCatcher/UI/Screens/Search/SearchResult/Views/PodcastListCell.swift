//
//  PodcastResultCell.swift
//  Podcatch
//
//  Created by Christopher Webb-Orenstein on 2/3/18.
//  Copyright © 2018 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

final class PodcastListCell: UICollectionViewCell, BaseDetailCell {
    
    // MARK: - UI Properties
    
    var model: PodcastResultCellViewModel!
    
    private var regularConstraints: [NSLayoutConstraint] = []
    private var regularTitleConstraints: [NSLayoutConstraint] = []
    private var modified: [NSLayoutConstraint] = []
    private var modifiedTitle: [NSLayoutConstraint] = []
    private var buttonConstraints: [NSLayoutConstraint] = []
    private var buttonModified: [NSLayoutConstraint] = []
    private var playtimeModified: [NSLayoutConstraint] = []
    private var playtimeRegularConstraints = [NSLayoutConstraint]()
    
    weak var delegate: PodcastResultCellDelegate?
    
    var colorBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.alpha = 1
        return view
    }()
    
    private var separatorView: UIView = {
        let separatorView = UIView()
        separatorView.backgroundColor = .lightGray
        separatorView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return separatorView
    }()
    
    private var moreButton: UIButton = {
        let moreButton = UIButton()
        moreButton.setImage(#imageLiteral(resourceName: "more-icon").withRenderingMode(.alwaysTemplate), for: .normal)
        //moreButton.setImage(#imageLiteral(resourceName: "more-icon").withRenderingMode(.alwaysTemplate), for: .normal)
        moreButton.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        moreButton.tintColor = .darkGray
        return moreButton
    }()
    
    private var podcastTitleLabel: UILabel = {
        var podcastTitleLabel = UILabel()
        podcastTitleLabel.textAlignment = .left
        podcastTitleLabel.textColor = .darkGray
        podcastTitleLabel.lineBreakMode   = .byClipping
        podcastTitleLabel.clipsToBounds = true
        podcastTitleLabel.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        podcastTitleLabel.numberOfLines = 1
        podcastTitleLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        return podcastTitleLabel
    }()
    
    private var playTimeLabel: UILabel = {
        var playTimeLabel = UILabel()
        playTimeLabel.sizeToFit()
        playTimeLabel.textAlignment = .left
        playTimeLabel.textColor = .gray
        playTimeLabel.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        playTimeLabel.font = UIFont.systemFont(ofSize: 12, weight: .light)
        //UIFont(name: "AvenirNext-Regular", size: 12)
        return playTimeLabel
    }()
    
    var audioAnimation: AudioIndicatorView!
    // MARK: - Configuration Methods
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        isUserInteractionEnabled = true
        contentView.layer.borderColor = UIColor.clear.cgColor
        setupSeparator()
    }
    
    private func setup(separatorView: UIView) {
        contentView.addSubview(separatorView)
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        regularConstraints = [
            separatorView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.01),
            separatorView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            separatorView.rightAnchor.constraint(equalTo: rightAnchor),
            separatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ]
        NSLayoutConstraint.activate(regularTitleConstraints)
        NSLayoutConstraint.activate(regularConstraints)
        NSLayoutConstraint.activate(playtimeRegularConstraints)
        NSLayoutConstraint.activate(buttonConstraints)
    }
    
    func setupAudio() {
        let frame = moreButton.frame
        moreButton.tintColor = .clear
        moreButton.isEnabled = false
        audioAnimation = AudioIndicatorView(frame: frame, animationType: AudioEqualizer2())
        audioAnimation.frame = frame
        contentView.add(audioAnimation)
        audioAnimation.startAnimating()
    }
    
    func removeAudio() {
        audioAnimation.stopAnimating()
        audioAnimation.removeFromSuperview()
        moreButton.tintColor = .darkGray
        moreButton.isEnabled = true
    }
    
    private func setupSeparator() {
        setup(separatorView: separatorView)
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            let containerLayer = CALayer()
            containerLayer.shadowColor = UIColor.darkText.cgColor
            containerLayer.shadowRadius = 1
            containerLayer.shadowOffset = CGSize(width: 0, height: 0)
            containerLayer.shadowOpacity = 0.7
            strongSelf.layer.addSublayer(containerLayer)
        }
    }
    
    @objc func buttonTap() {
        delegate?.moreButtonTapped(sender: moreButton, cell: self)
    }
    
    func configureCell(model: PodcastResultCellViewModel) {
        self.model = model
        guard let episode = model.episode else { return }
        configure(with: episode.title, detail: model.playtimeLabel)
    }
    
    func configure(with title: String, detail: String) {
        layoutSubviews()
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        setupConstraints()
        moreButton.addTarget(self, action: #selector(buttonTap), for: .touchUpInside)
        layoutIfNeeded()
        colorBackgroundView.frame = contentView.frame
        contentView.addSubview(colorBackgroundView)
        contentView.sendSubview(toBack: colorBackgroundView)
        podcastTitleLabel.text = title
        playTimeLabel.text = detail
    }
    
    private func setupConstraints() {
        self.updateConstraintsIfNeeded()
        contentView.addSubview(podcastTitleLabel)
        podcastTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        regularTitleConstraints = [
            podcastTitleLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: PodcastCellConstants.podcastTitleLabelWidthMultiplier),
            podcastTitleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: PodcastCellConstants.podcastTitleLabelLeftOffset + 20),
            podcastTitleLabel.topAnchor.constraint(equalTo: topAnchor, constant: contentView.frame.height * 0.2)
        ]
        contentView.addSubview(playTimeLabel)
        playTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        playtimeRegularConstraints = [
            playTimeLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: contentView.frame.height * -0.2),
            playTimeLabel.leftAnchor.constraint(equalTo: podcastTitleLabel.leftAnchor),
            playTimeLabel.widthAnchor.constraint(equalTo: podcastTitleLabel.widthAnchor)
        ]
        
        contentView.addSubview(moreButton)
        moreButton.translatesAutoresizingMaskIntoConstraints = false
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 480, 960, 1136:
                buttonConstraints = [
                    moreButton.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.084),
                    moreButton.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.4),
                    moreButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: PodcastCellConstants.playtimeLabelRightOffset),
                    moreButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
                ]
            case 1334, 2208:
                buttonConstraints = [
                    moreButton.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.087),
                    moreButton.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.4),
                    moreButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: PodcastCellConstants.playtimeLabelRightOffset),
                    moreButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
                ]
            default:
                buttonConstraints = [
                    moreButton.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.084),
                    moreButton.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.4),
                    moreButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: PodcastCellConstants.playtimeLabelRightOffset),
                    moreButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
                ]
            }
        }
    }
    
    override func prepareForReuse() {
        if (audioAnimation) != nil {
            removeAudio()
        }
    }
}
