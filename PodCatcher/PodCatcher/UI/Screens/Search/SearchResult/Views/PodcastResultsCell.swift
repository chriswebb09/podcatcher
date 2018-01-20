import UIKit

final class PodcastResultCell: UICollectionViewCell {
    
    // MARK: - UI Properties
    
    var colorBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.alpha = 1
        return view
    }()
    
    private var moreButton: UIButton = {
        let moreButton = UIButton()
        moreButton.setImage(#imageLiteral(resourceName: "more-button-circle").withRenderingMode(.alwaysTemplate), for: .normal)
        moreButton.tintColor = .darkGray
        return moreButton
    }()
    
    private var podcastTitleLabel: UILabel = {
        var podcastTitleLabel = UILabel()
        podcastTitleLabel.numberOfLines = 0
        podcastTitleLabel.textAlignment = .left
        podcastTitleLabel.textColor = .darkGray
        podcastTitleLabel.font = UIFont(name: "AvenirNext-Regular", size: 14)
        return podcastTitleLabel
    }()
    
    private var playTimeLabel: UILabel = {
        var playTimeLabel = UILabel()
        playTimeLabel.sizeToFit()
        playTimeLabel.textAlignment = .left
        playTimeLabel.textColor = .darkGray
        playTimeLabel.font = UIFont(name: "AvenirNext-Regular", size: 12)
        return playTimeLabel
    }()
    
    // MARK: - Configuration Methods
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth, .flexibleTopMargin, .flexibleBottomMargin]
        isUserInteractionEnabled = true
        contentView.layer.borderColor = UIColor.clear.cgColor
        contentView.layer.masksToBounds = true
        layer.podcastCell(viewRadius: contentView.layer.cornerRadius + 10)
        contentView.layer.setCellShadow(contentView: contentView)
    }
    
    func configureCell(model: PodcastResultCellViewModel) {
        layoutSubviews()
        setupConstraints()
        layoutIfNeeded()
        colorBackgroundView.frame = contentView.frame
        contentView.addSubview(colorBackgroundView)
        contentView.sendSubview(toBack: colorBackgroundView)
        podcastTitleLabel.text = model.podcastTitle
        playTimeLabel.text = model.playtimeLabel
    }
    
    private func setupConstraints() {
        self.updateConstraintsIfNeeded()
        
        contentView.addSubview(podcastTitleLabel)
        podcastTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            podcastTitleLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: PodcastCellConstants.podcastTitleLabelWidthMultiplier),
            podcastTitleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: PodcastCellConstants.podcastTitleLabelLeftOffset + 5),
            podcastTitleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: contentView.frame.height * 0.2)
            ])
        
        contentView.addSubview(playTimeLabel)
        playTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            playTimeLabel.topAnchor.constraint(equalTo: podcastTitleLabel.bottomAnchor, constant: contentView.frame.height * 0.16),
            playTimeLabel.leftAnchor.constraint(equalTo: podcastTitleLabel.leftAnchor),
            playTimeLabel.widthAnchor.constraint(equalTo: podcastTitleLabel.widthAnchor)
            ])
        
        contentView.add(moreButton)
        moreButton.translatesAutoresizingMaskIntoConstraints = false
        
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 480:
                print("iPhone Classic")
            case 960:
                NSLayoutConstraint.activate([
                    moreButton.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.076),
                    moreButton.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.39),
                    moreButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: PodcastCellConstants.playtimeLabelRightOffset),
                    moreButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
                    ])
            case 1136:
                NSLayoutConstraint.activate([
                    moreButton.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.076),
                    moreButton.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.4),
                    moreButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: PodcastCellConstants.playtimeLabelRightOffset),
                    moreButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
                    ])
            case 1334:
                NSLayoutConstraint.activate([
                    moreButton.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.076),
                    moreButton.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.42),
                    moreButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: PodcastCellConstants.playtimeLabelRightOffset),
                    moreButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
                    ])
            case 2208:
                NSLayoutConstraint.activate([
                    moreButton.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.076),
                    moreButton.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.39),
                    moreButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: PodcastCellConstants.playtimeLabelRightOffset),
                    moreButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
                    ])
            default:
                NSLayoutConstraint.activate([
                    moreButton.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.076),
                    moreButton.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.39),
                    moreButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: PodcastCellConstants.playtimeLabelRightOffset),
                    moreButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
                    ])
            }
        }
                
       
    }
}
