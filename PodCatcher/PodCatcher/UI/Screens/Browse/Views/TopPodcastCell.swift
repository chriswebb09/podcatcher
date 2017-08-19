import UIKit

final internal class TopPodcastCell: UICollectionViewCell {
    
    private var viewModel: TopPodcastCellViewModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            trackNameLabel.text = viewModel.trackName
            albumArtView.image = viewModel.podcastImage
        }
    }
    
    var albumArtView: UIImageView = {
        var album = UIImageView()
        return album
    }()
    
    private var titleView: UIView = {
        var titleView = UIView()
        titleView.backgroundColor = .clear
        return titleView
    }()
    
    
    private var titleBackgroundView: UIView = {
        var titleView = UIView()
        titleView.backgroundColor = .black
        titleView.alpha = 0.6
        //titleView.layer.cornerRadius = 3
        return titleView
    }()
    
    
    var trackNameLabel: UILabel = {
        var trackName = UILabel()
        trackName.font = UIFont.systemFont(ofSize: 14, weight: UIFontWeightSemibold)
        trackName.textAlignment = .center
        trackName.textColor = .white
        trackName.numberOfLines = 0
        return trackName
    }()
    
    // Cell shadow
    
    private func setShadow() {
        layer.setCellShadow(contentView: contentView)
        let rect = CGRect(origin: bounds.origin, size: CGSize(width: bounds.width, height: bounds.height - 10))
        let path =  UIBezierPath(roundedRect: rect, cornerRadius: contentView.layer.cornerRadius)
        layer.shadowPath = path.cgPath
    }
    
    func configureCell(with imageUrl: URL, title: String) {
        trackNameLabel.text = title
        albumArtView.image = #imageLiteral(resourceName: "placeholder")
        albumArtView.downloadImage(url: imageUrl)
        //layer.borderWidth = 1
      //  contentView.layer.cornerRadius = 3
       // layer.borderColor = UIColor.lightText.cgColor
      //  contentView.backgroundColor = Colors.lightCharcoal
        albumArtView.layer.setCellShadow(contentView: self)
    }
    
    func configureCell(with model: TopPodcastCellViewModel, withTime: Double) {
        viewModel = model
       // layer.borderWidth = 1
       // contentView.layer.cornerRadius = 3
       // layer.borderColor = UIColor.lightText.cgColor
        //contentView.backgroundColor = Colors.lightCharcoal
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        viewConfigurations()
    }
    
    // MARK: View setup methods
    
    private func viewConfigurations() {
        setShadow()
        setup(albumArtView: albumArtView)
        setup(titleView: titleView)
        setup(titleBackgroundView: titleBackgroundView)
        setup(trackNameLabel: trackNameLabel)
        //layer.cornerRadius = 4
    }
    
    private func setup(albumArtView: UIImageView) {
        contentView.addSubview(albumArtView)
        albumArtView.translatesAutoresizingMaskIntoConstraints = false
        albumArtView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive =  true
        albumArtView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        albumArtView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.8).isActive = true
        albumArtView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.9).isActive = true
    }
    
    private func setup(titleView: UIView) {
        albumArtView.addSubview(titleView)
        titleView.translatesAutoresizingMaskIntoConstraints = false
        titleView.heightAnchor.constraint(equalTo: albumArtView.heightAnchor, multiplier: 0.3).isActive = true
        titleView.widthAnchor.constraint(equalTo: albumArtView.widthAnchor).isActive = true
        titleView.bottomAnchor.constraint(equalTo: albumArtView.bottomAnchor).isActive = true
        titleView.centerXAnchor.constraint(equalTo: albumArtView.centerXAnchor).isActive = true
    }
    
    private func setup(titleBackgroundView: UIView) {
        titleView.addSubview(titleBackgroundView)
        titleBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        titleBackgroundView.heightAnchor.constraint(equalTo: titleView.heightAnchor).isActive = true
        titleBackgroundView.widthAnchor.constraint(equalTo: titleView.widthAnchor).isActive = true
        titleBackgroundView.bottomAnchor.constraint(equalTo: titleView.bottomAnchor).isActive = true
        titleBackgroundView.centerXAnchor.constraint(equalTo: titleView.centerXAnchor).isActive = true
    }
    
    private func setup(trackNameLabel: UILabel) {
        titleView.addSubview(trackNameLabel)
        trackNameLabel.translatesAutoresizingMaskIntoConstraints = false
        trackNameLabel.heightAnchor.constraint(equalTo: titleView.heightAnchor).isActive = true
        trackNameLabel.widthAnchor.constraint(equalTo: titleView.widthAnchor, multiplier: 0.8).isActive = true
        trackNameLabel.centerYAnchor.constraint(equalTo: titleView.centerYAnchor).isActive = true
        trackNameLabel.centerXAnchor.constraint(equalTo: titleView.centerXAnchor).isActive = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        albumArtView.image = nil
        trackNameLabel.text = ""
    }
    
    private func displayCellContent(_ model: TopPodcastCellViewModel?) {
        self.viewModel = model
        if let viewModel = viewModel {
            albumArtView.image = viewModel.podcastImage
            trackNameLabel.text = viewModel.trackName
        }
    }
    
    func updateAppearanceFor(_ model: TopPodcastCellViewModel?, animated: Bool = true) {
        DispatchQueue.main.async {
            if animated {
                UIView.animate(withDuration: 0.5) {
                    self.displayCellContent(model)
                }
            } else {
                self.displayCellContent(model)
            }
        }
    }
}
