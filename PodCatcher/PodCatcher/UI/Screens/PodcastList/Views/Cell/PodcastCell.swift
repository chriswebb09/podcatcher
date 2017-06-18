import UIKit

class PodcastCell: UICollectionViewCell {
    
    // MARK: - UI Properties
    
    var colorBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.alpha = 0.05
        return view
    }()
    
    var podcastTitleLabel: UILabel = {
        var podcastTitleLabel = UILabel()
        podcastTitleLabel.numberOfLines = 0
       // podcastTitleLabel.sizeToFit()
        podcastTitleLabel.textAlignment = .center
        podcastTitleLabel.textColor = .white
        podcastTitleLabel.font = UIFont(name: "HelveticaNeue-Light", size: 11)
        return podcastTitleLabel
    }()
    
    var playTimeLabel: UILabel = {
        var playTimeLabel = UILabel()
        playTimeLabel.sizeToFit()
        playTimeLabel.textAlignment = .right
        playTimeLabel.textColor = .white
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
        layer.podcastCell(viewRadius: contentView.layer.cornerRadius + 20)
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

