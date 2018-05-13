import UIKit

final class TopView: UIView {
    
    weak var delegate: TopViewDelegate?
    
    // MARK: - UI Properties
    
    var podcastImageView: UIImageView! = {
        var podcastImageView = UIImageView()
        podcastImageView.layer.setCellShadow(contentView: podcastImageView)
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
        podcastImageView.layer.setCellShadow(contentView: podcastImageView)
    }
    
    func setupConstraints() {
        setup(podcastImageView: podcastImageView)
        setup(titleLabel: podcastTitleLabel)
        setup(preferencesView: preferencesView)
        preferencesView.layoutSubviews()
        podcastImageView.layer.setCellShadow(contentView: podcastImageView)
    }
    
    func setup(podcastImageView: UIImageView) {
        addSubview(podcastImageView)
        podcastImageView.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 11, *) {
            NSLayoutConstraint.activate([
                podcastImageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0),
                podcastImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.74),
                podcastImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.88)
                ])
        } else {
            NSLayoutConstraint.activate([
                podcastImageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: PodcastListTopViewConstants.podcastImageViewCenterYOffset),
                podcastImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: PodcastListTopViewConstants.preferencesViewHeightMultiplier),
                podcastImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: PodcastListTopViewConstants.imageHeightMultiplier)
                ])
        }
        NSLayoutConstraint.activate([
            podcastImageView.centerXAnchor.constraint(equalTo: centerXAnchor)
            ])
    }
    //static let podcastImageViewHeightMultiplier: CGFloat = 0.87
    func setup(titleLabel: UILabel) {
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: podcastImageView.bottomAnchor, constant: PodcastListTopViewConstants.titleLabelTopOffset),
            titleLabel.widthAnchor.constraint(equalTo: widthAnchor),
            titleLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: PodcastListTopViewConstants.titleLabelHeightMultiplier)
            ])
    }
    
    func setup(preferencesView: UIView) {
        addSubview(preferencesView)
        preferencesView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            preferencesView.widthAnchor.constraint(equalTo: widthAnchor),
            preferencesView.bottomAnchor.constraint(equalTo: bottomAnchor),
            preferencesView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: PodcastListTopViewConstants.preferencesViewHeightMultiplier)
            ])
    }
}
