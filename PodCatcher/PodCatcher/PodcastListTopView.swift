import UIKit

class PodcastListTopView: UIView {
    
    var podcastImageView: UIImageView! = {
        var podcastImageView = UIImageView()
        return podcastImageView
    }()
    
    var podcastTitleLabel: UILabel! = {
        var podcastTitle = UILabel()
        podcastTitle.textAlignment = .center
        return podcastTitle
    }()
    
    var playCountLabel: UILabel!
    var genreLabel: UIView!
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupConstraints()
        backgroundColor = .lightGray
    }
    
    func setupConstraints() {
        setup(podcastImageView: podcastImageView)
        setup(titleLabel: podcastTitleLabel)
    }
    
    func setup(podcastImageView: UIImageView) {
        addSubview(podcastImageView)
        podcastImageView.translatesAutoresizingMaskIntoConstraints = false
        podcastImageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: UIScreen.main.bounds.height * -0.04).isActive = true
        podcastImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        podcastImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.6).isActive = true
        podcastImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.4).isActive = true
    }
    
    func setup(titleLabel: UILabel) {
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: podcastImageView.bottomAnchor, constant: UIScreen.main.bounds.height * 0.001).isActive = true
        titleLabel.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        titleLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.3).isActive = true
    }
    
}
