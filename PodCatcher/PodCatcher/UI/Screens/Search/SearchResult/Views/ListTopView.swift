import UIKit

final class ListTopView: UIView {
    
    weak var delegate: TopViewDelegate?
    
    // MARK: - UI Properties
    
    var podcastImageView: UIImageView! = {
        var podcastImageView = UIImageView()
        podcastImageView.layer.setCellShadow(contentView: podcastImageView)
        podcastImageView.layer.cornerRadius = 6
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
        podcastImageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: PodcastListTopViewConstants.podcastImageViewCenterYOffset).isActive = true
        podcastImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        podcastImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: PodcastListTopViewConstants.podcastImageViewHeightMultiplier).isActive = true
        podcastImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: PodcastListTopViewConstants.podcastImageViewWidthMultiplier).isActive = true
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
        preferencesView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: PodcastListTopViewConstants.preferencesViewHeightMultiplier).isActive = true
    }
}

// MARK: - PreferencesViewDelegate

extension ListTopView: PreferencesViewDelegate {
    
    func addTagButton(tapped: Bool) {
        delegate?.entryPop(popped: tapped)
    }
    
    func moreButton(tapped: Bool) {
        delegate?.popBottomMenu(popped: tapped)
    }
}
