import UIKit

class PodcastCell: UICollectionViewCell {
    
    // MARK: - UI Properties
    
    var colorBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.alpha = 1
        return view
    }()
    
    var podcastTitleLabel: UILabel = {
        var podcastTitleLabel = UILabel()
        podcastTitleLabel.numberOfLines = 0
        // podcastTitleLabel.sizeToFit()
        podcastTitleLabel.textAlignment = .left
        podcastTitleLabel.textColor = .darkGray
        //podcastTitleLabel.textColor = UIColor(red:0.96, green:0.26, blue:0.21, alpha:1.0)
        podcastTitleLabel.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 12)
        return podcastTitleLabel
    }()
    
    var playTimeLabel: UILabel = {
        var playTimeLabel = UILabel()
        playTimeLabel.sizeToFit()
        playTimeLabel.textAlignment = .right
        playTimeLabel.textColor = .black
        playTimeLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 11)
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
    
    func configureCell(model: PodcastCellViewModel) {
        layoutSubviews()
        setupConstraints()
        layoutIfNeeded()
        colorBackgroundView.frame = contentView.frame
        contentView.addSubview(colorBackgroundView)
        contentView.sendSubview(toBack: colorBackgroundView)
        //  podcastImageView.image = model.podcastImage
        playTimeLabel.text = String.constructTimeString(time: model.item.playtime)
        podcastTitleLabel.text = model.podcastTitle
        contentView.layer.borderColor = UIColor.lightGray.cgColor
        contentView.layer.borderWidth = 1
        
    }
    
    func setupConstraints() {
        self.updateConstraintsIfNeeded()
        contentView.addSubview(podcastTitleLabel)
        podcastTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        podcastTitleLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: PodcastCellConstants.podcastTitleLabelWidthMultiplier).isActive = true
        podcastTitleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: PodcastCellConstants.podcastTitleLabelLeftOffset).isActive = true
        podcastTitleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        contentView.addSubview(playTimeLabel)
        playTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        playTimeLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: PodcastCellConstants.playtimeLabelWidthMultiplier).isActive = true
        playTimeLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: PodcastCellConstants.playtimeLabelRightOffset).isActive = true
        playTimeLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }
}

