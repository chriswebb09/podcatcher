import UIKit

class PodcastListTopView: UIView {
    
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
    
    var playCountLabel: UILabel! = {
        var playCountLabel = UILabel()
        return playCountLabel
    }()
    
    var genreLabel: UILabel! = {
        var genreLabel = UILabel()
        return genreLabel
    }()
    
    var preferencesView: PreferencesView = {
        var preferencesView = PreferencesView()
        preferencesView.layoutSubviews()
        return preferencesView
    }()

    override func layoutSubviews() {
        super.layoutSubviews()
        setupConstraints()
        backgroundColor = .lightGray
        layer.setCellShadow(contentView: self)
    }
    
    func setupConstraints() {
        setup(podcastImageView: podcastImageView)
        setup(titleLabel: podcastTitleLabel)
        setup(preferencesView: preferencesView)
        preferencesView.layoutSubviews()
    }
    
    func setup(podcastImageView: UIImageView) {
        addSubview(podcastImageView)
        podcastImageView.translatesAutoresizingMaskIntoConstraints = false
        podcastImageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: UIScreen.main.bounds.height * -0.04).isActive = true
        podcastImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        podcastImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.6).isActive = true
        podcastImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.38).isActive = true
    }
    
    func setup(titleLabel: UILabel) {
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: podcastImageView.bottomAnchor, constant: UIScreen.main.bounds.height * 0.001).isActive = true
        titleLabel.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        titleLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.3).isActive = true
    }
    
    
    func setup(preferencesView: UIView) {
        addSubview(preferencesView)
        preferencesView.translatesAutoresizingMaskIntoConstraints = false
        preferencesView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        preferencesView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        preferencesView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.25).isActive = true
    }
    
}
