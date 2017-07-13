import UIKit

struct BrowseListTopViewConstants {
    static let podcastImageViewCenterYOffset: CGFloat = UIScreen.main.bounds.height * -0.03
    static let preferencesViewHeightMultiplier: CGFloat = 0.12
    static let tagsViewHeightMultiplier: CGFloat = 0.13
    static let podcastImageViewHeightMultiplier: CGFloat = 0.70
    static let podcastImageViewWidthMultiplier: CGFloat = 0.70
    static let titleLabelHeightMultiplier: CGFloat = 0.3
    static let titleLabelTopOffset: CGFloat = UIScreen.main.bounds.height * 0.0008
}


final class BrowseTopView: UIView {
    
    weak var delegate: TopViewDelegate?
    
    // MARK: - UI Properties
    
    var podcastImageView: UIImageView! = {
        var podcastImageView = UIImageView()
        podcastImageView.layer.setCellShadow(contentView: podcastImageView)
        podcastImageView.layer.cornerRadius = 2
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
        layer.setCellShadow(contentView: self)
        backgroundColor = UIColor(red:0.84, green:0.85, blue:0.86, alpha:1.0)
    }
    
    func setupConstraints() {
        setup(podcastImageView: podcastImageView)
        setup(titleLabel: podcastTitleLabel)
        preferencesView.layoutSubviews()
    }
    
    func setup(podcastImageView: UIImageView) {
        addSubview(podcastImageView)
        podcastImageView.translatesAutoresizingMaskIntoConstraints = false
        podcastImageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: PodcastListTopViewConstants.podcastImageViewCenterYOffset).isActive = true
        podcastImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        podcastImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: BrowseListTopViewConstants.podcastImageViewHeightMultiplier).isActive = true
        podcastImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: BrowseListTopViewConstants.podcastImageViewWidthMultiplier).isActive = true
    }
    
    func setup(titleLabel: UILabel) {
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: podcastImageView.bottomAnchor, constant: PodcastListTopViewConstants.titleLabelTopOffset).isActive = true
        titleLabel.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        titleLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: PodcastListTopViewConstants.titleLabelHeightMultiplier).isActive = true
    }
}
