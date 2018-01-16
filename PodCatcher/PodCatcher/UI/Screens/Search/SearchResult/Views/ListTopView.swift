import UIKit

final class ListTopView: UIView {
    
    weak var delegate: TopViewDelegate?
    
    // MARK: - UI Properties
    
    var podcastImageView: UIImageView! = {
        var podcastImageView = UIImageView()
        podcastImageView.layer.setCellShadow(contentView: podcastImageView)
        podcastImageView.layer.cornerRadius = 6
        podcastImageView.layer.borderWidth = 1
        podcastImageView.layer.borderColor = UIColor.darkGray.cgColor
        return podcastImageView
    }()
    
    var podcastTitleLabel: UILabel! = {
        var podcastTitle = UILabel()
        podcastTitle.textAlignment = .center
        return podcastTitle
    }()
    
    var preferencesView: PreferencesView = {
        var preferencesView = PreferencesView()
        preferencesView.layoutSubviews()
        return preferencesView
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupConstraints()
        backgroundColor = .white
        layer.setCellShadow(contentView: self)
    }
    
    func setupConstraints() {
        setup(podcastImageView: podcastImageView)
        setup(titleLabel: podcastTitleLabel)
        setup(preferencesView: preferencesView)
        preferencesView.layoutSubviews()
        preferencesView.delegate = self
        
    }
    
    func setup(podcastImageView: UIImageView) {
        addSubview(podcastImageView)
        podcastImageView.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 11, *) {
            NSLayoutConstraint.activate([
                podcastImageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -1 * UIScreen.main.bounds.height * 0.03),
                podcastImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
                podcastImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.7),
                podcastImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.65)
                ])
        } else {
            NSLayoutConstraint.activate([
                podcastImageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: PodcastListTopViewConstants.podcastImageViewCenterYOffset),
                podcastImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
                podcastImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: PodcastListTopViewConstants.podcastImageViewHeightMultiplier),
                podcastImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: PodcastListTopViewConstants.podcastImageViewWidthMultiplier)
                ])
        }
        podcastImageView.layoutIfNeeded()
        layoutIfNeeded()
    }
    
    func setup(titleLabel: UILabel) {
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: podcastImageView.bottomAnchor, constant: PodcastListTopViewConstants.titleLabelTopOffset).isActive = true
        titleLabel.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        titleLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: PodcastListTopViewConstants.titleLabelHeightMultiplier).isActive = true
    }
    
    func setup(preferencesView: UIView) {
        addSubview(preferencesView)
        preferencesView.translatesAutoresizingMaskIntoConstraints = false
        preferencesView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        preferencesView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        if #available(iOS 11, *) {
            preferencesView.heightAnchor.constraint(equalTo: heightAnchor,  multiplier: 0.13).isActive = true
        } else {
            preferencesView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: PodcastListTopViewConstants.preferencesViewHeightMultiplier).isActive = true
        }
        preferencesView.layoutIfNeeded()
    }
    
    func configureTopImage() {
        podcastImageView.layer.cornerRadius = 4
        podcastImageView.layer.masksToBounds = true
        layer.setCellShadow(contentView: self)
        podcastImageView.layer.setCellShadow(contentView: podcastImageView)
    }
}

// MARK: - PreferencesViewDelegate

extension ListTopView: PreferencesViewDelegate {
    func infoButton(tapped: Bool) {
        print("TAPPERS")
        delegate?.infoButton(tapped: true)
    }
    
    func addTagButton(tapped: Bool) {
        delegate?.entryPop(popped: tapped)
    }
    
    func moreButton(tapped: Bool) {
        delegate?.popBottomMenu(popped: tapped)
    }
}
