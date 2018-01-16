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
        return titleView
    }()
    
    
    var trackNameLabel: UILabel = {
        var trackName = UILabel()
        trackName.font = UIFont(name: "AvenirNext-DemiBold", size: 14)
            //UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.semibold)
        trackName.textAlignment = .center
        trackName.textColor = .white
        trackName.numberOfLines = 0
        return trackName
    }()
    
    // Cell shadow
    
//    private func setShadow() {
//        layer.setCellShadow(contentView: contentView)
//        let rect = CGRect(origin: bounds.origin, size: CGSize(width: bounds.width, height: bounds.height - 10))
//        let path =  UIBezierPath(roundedRect: rect, cornerRadius: contentView.layer.cornerRadius)
//        layer.shadowPath = path.cgPath
//    }
//
    func configureCell(with imageUrl: URL, title: String) {
        trackNameLabel.text = title
        albumArtView.image = #imageLiteral(resourceName: "placeholder")
        albumArtView.downloadImage(url: imageUrl)
        albumArtView.layer.setCellShadow(contentView: self)
    }
    
    func configureCell(with model: TopPodcastCellViewModel, withTime: Double) {
        viewModel = model
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        viewConfigurations()
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.albumArtView.layer.cornerRadius = 4
            let containerLayer = CALayer()
            containerLayer.shadowColor = UIColor.darkText.cgColor
            containerLayer.shadowRadius = 1
            containerLayer.shadowOffset = CGSize(width: 0, height: 0)
            containerLayer.shadowOpacity = 0.5
            strongSelf.albumArtView.layer.masksToBounds = true
            containerLayer.addSublayer(strongSelf.albumArtView.layer)
            strongSelf.layer.addSublayer(containerLayer)
        }
    }
    
    // MARK: View setup methods
    
    private func viewConfigurations() {
        setup(albumArtView: albumArtView)
        setup(titleView: titleView)
        setup(titleBackgroundView: titleBackgroundView)
        setup(trackNameLabel: trackNameLabel)
    }
    
    private func setup(albumArtView: UIImageView) {
        contentView.addSubview(albumArtView)
        albumArtView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            albumArtView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            albumArtView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            albumArtView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.8),
            albumArtView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.9)
            ])
    }
    
    private func setup(titleView: UIView) {
        albumArtView.addSubview(titleView)
        titleView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleView.heightAnchor.constraint(equalTo: albumArtView.heightAnchor, multiplier: 0.3),
            titleView.widthAnchor.constraint(equalTo: albumArtView.widthAnchor),
            titleView.bottomAnchor.constraint(equalTo: albumArtView.bottomAnchor),
            titleView.centerXAnchor.constraint(equalTo: albumArtView.centerXAnchor)
            ])
    }
    
    private func setup(titleBackgroundView: UIView) {
        titleView.addSubview(titleBackgroundView)
        titleBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleBackgroundView.heightAnchor.constraint(equalTo: titleView.heightAnchor),
            titleBackgroundView.widthAnchor.constraint(equalTo: titleView.widthAnchor),
            titleBackgroundView.bottomAnchor.constraint(equalTo: titleView.bottomAnchor),
            titleBackgroundView.centerXAnchor.constraint(equalTo: titleView.centerXAnchor)
            ])
    }
    
    private func setup(trackNameLabel: UILabel) {
        titleView.addSubview(trackNameLabel)
        trackNameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            trackNameLabel.heightAnchor.constraint(equalTo: titleView.heightAnchor),
            trackNameLabel.widthAnchor.constraint(equalTo: titleView.widthAnchor, multiplier: 0.8),
            trackNameLabel.centerYAnchor.constraint(equalTo: titleView.centerYAnchor),
            trackNameLabel.centerXAnchor.constraint(equalTo: titleView.centerXAnchor)
            ])
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
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            if animated {
                UIView.animate(withDuration: 0.5) {
                    strongSelf.displayCellContent(model)
                }
            } else {
                strongSelf.displayCellContent(model)
            }
        }
    }
}
