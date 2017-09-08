import UIKit

final class PodcastPlaylistCell: UICollectionViewCell {
    
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
        podcastTitleLabel.textAlignment = .left
        podcastTitleLabel.textColor = .darkGray
        podcastTitleLabel.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.thin)
        return podcastTitleLabel
    }()
    
    var playButton: UIButton = {
        var play = UIButton()
        play.setImage(#imageLiteral(resourceName: "play"), for: .normal)
        play.alpha = 0.6
        play.tintColor = .black
        return play
    }()
    
    var pauseButton: UIButton = {
        var pause = UIButton()
        pause.setImage(#imageLiteral(resourceName: "pause-round"), for: .normal)
        pause.alpha = 0.6
        pause.tintColor = .black
        return pause
    }()
    
    // MARK: - Configuration Methods
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth, .flexibleTopMargin, .flexibleBottomMargin]
        isUserInteractionEnabled = true
        contentView.layer.borderColor = UIColor.clear.cgColor
        contentView.layer.masksToBounds = true
        pauseButton.isHidden = true
        layer.podcastCell(viewRadius: contentView.layer.cornerRadius + 10)
        contentView.layer.setCellShadow(contentView: contentView)
    }
    
    func configureCell(model: PodcastCellViewModel) {
        backgroundColor = .lightGray
        layoutSubviews()
        setupConstraints()
        buttonConstraint(button: pauseButton)
        buttonConstraint(button: playButton)
        layoutIfNeeded()
        colorBackgroundView.frame = contentView.frame
        contentView.addSubview(colorBackgroundView)
        contentView.sendSubview(toBack: colorBackgroundView)
        podcastTitleLabel.text = model.podcastTitle
    }
    
    func switchAlpha(hidden: Bool) {
        pauseButton.isHidden = hidden
        playButton.isHidden = !hidden
    }
    
    func setupConstraints() {
        self.updateConstraintsIfNeeded()
        contentView.addSubview(podcastTitleLabel)
        podcastTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        podcastTitleLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: PodcastCellConstants.podcastTitleLabelWidthMultiplier).isActive = true
        podcastTitleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: PodcastCellConstants.podcastTitleLabelLeftOffset).isActive = true
        podcastTitleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }
    
    func buttonConstraint(button: UIButton) {
        contentView.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.095).isActive = true
        button.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.49).isActive = true
        button.centerXAnchor.constraint(equalTo: centerXAnchor, constant: contentView.bounds.width * 0.42).isActive = true
        button.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }
}
