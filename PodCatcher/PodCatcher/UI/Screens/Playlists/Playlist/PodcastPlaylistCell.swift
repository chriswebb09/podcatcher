import UIKit

final class PodcastPlaylistCell: UICollectionViewCell {
    
    enum CellState {
        case playing
        case paused
    }
    
    var currentState: CellState = .paused {
        didSet {
            switch currentState {
            case .paused:
                playButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
            case .playing:
                playButton.setImage(#imageLiteral(resourceName: "pause-round"), for: .normal)
            }
        }
    }
    
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
        podcastTitleLabel.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.thin)
        return podcastTitleLabel
    }()
    
    var playButton: UIButton = {
        var play = UIButton()
        play.setImage(#imageLiteral(resourceName: "play"), for: .normal)
        play.alpha = 0.6
        play.tintColor = .black
        return play
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
        backgroundColor = .lightGray
        layoutSubviews()
        setupConstraints()
        buttonConstraint(button: playButton)
        layoutIfNeeded()
        colorBackgroundView.frame = contentView.frame
        contentView.addSubview(colorBackgroundView)
        contentView.sendSubview(toBack: colorBackgroundView)
        podcastTitleLabel.text = model.podcastTitle
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
        if #available(iOS 11, *) {
            NSLayoutConstraint.activate([
                button.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.08),
                button.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.4),
                button.centerXAnchor.constraint(equalTo: centerXAnchor, constant: contentView.bounds.width * 0.40)
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
}
