import UIKit

final class BrowseTopView: UIView {
    
    weak var delegate: TopViewDelegate?
    
    // MARK: - UI Properties
    let sliderBarView = UIView()
    var sliderControl = SliderControl()
    
    var podcastImageView: UIImageView! = {
        var podcastImageView = UIImageView()
        podcastImageView.layer.setCellShadow(contentView: podcastImageView)
        podcastImageView.layer.cornerRadius = 2
        return podcastImageView
    }()
    
    var background = UIView()
    
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
        background.frame = frame
        addSubview(background)
        sendSubview(toBack: background)
        setupConstraints()
        layer.setCellShadow(contentView: self)
        layoutIfNeeded()
    }
    
    func setupConstraints() {
        setup(podcastImageView: podcastImageView)
        setup(titleLabel: podcastTitleLabel)
        preferencesView.layoutSubviews()
    }
    
    func setup(podcastImageView: UIImageView) {
        addSubview(podcastImageView)
        podcastImageView.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 11, *) {
            NSLayoutConstraint.activate([
                podcastImageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: UIScreen.main.bounds.height * -0.006),
                podcastImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
                podcastImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.7),
                podcastImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: BrowseListTopViewConstants.podcastImageViewWidthMultiplier)
                ])
        } else {
            NSLayoutConstraint.activate([
                podcastImageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: BrowseListTopViewConstants.podcastImageViewCenterYOffset),
                podcastImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
                podcastImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: BrowseListTopViewConstants.podcastImageViewHeightMultiplier),
                podcastImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: BrowseListTopViewConstants.podcastImageViewWidthMultiplier)
                ])
            podcastImageView.layoutIfNeeded()
            layoutIfNeeded()
        }
    }
    
    func setup(titleLabel: UILabel) {
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: podcastImageView.bottomAnchor, constant: PodcastListTopViewConstants.titleLabelTopOffset),
            titleLabel.widthAnchor.constraint(equalTo: widthAnchor),
            titleLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: PodcastListTopViewConstants.titleLabelHeightMultiplier)
            ])
    }
}
