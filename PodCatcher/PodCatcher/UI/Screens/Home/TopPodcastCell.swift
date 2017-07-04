import UIKit

struct TopPodcastCellViewModel {
    
    var trackName: String
    var albumImageUrl: URL
    
    init(trackName: String, albumImageUrl: URL) {
        self.trackName = trackName
        self.albumImageUrl = albumImageUrl
    }
}

struct TopPodcastCellConstants {
    static let smallFont = UIFont(name: "AvenirNext-Regular", size: 10)
    static let albumHeightMultiplier: CGFloat =  0.86
    static let labelHeightMultiplier: CGFloat = 0.25
}

final internal class TopPodcastCell: UICollectionViewCell {
    
    private var viewModel: TopPodcastCellViewModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            trackNameLabel.text = viewModel.trackName
            albumArtView.downloadImage(url: viewModel.albumImageUrl)
        }
    }
    
    private var albumArtView: UIImageView = {
        var album = UIImageView()
        return album
    }()
    
    private var titleView: UIView = {
        var titleView = UIView()
        titleView.backgroundColor = .white
        return titleView
    }()
    
    private var trackNameLabel: UILabel = {
        var trackName = UILabel()
        trackName.font = UIFont.systemFont(ofSize: 12, weight: UIFontWeightMedium)
        trackName.textAlignment = .center
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
    
    func configureCell(with model: TopPodcastCellViewModel, withTime: Double) {
        viewModel = model
        guard let viewModel = viewModel else { return }
        layer.borderWidth = 1
        contentView.layer.cornerRadius = 3
        layer.borderColor = UIColor.lightText.cgColor
        contentView.backgroundColor = Colors.lightCharcoal
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setup(albumArtView: albumArtView)
        setup(trackNameLabel: trackNameLabel)
        viewConfigurations()
    }
    
    // MARK: View setup methods
    
    private func viewConfigurations() {
        setShadow()
        setup(titleView: titleView)
        setup(albumArtView: albumArtView)
    }
    
    private func setup(albumArtView: UIImageView) {
        contentView.addSubview(albumArtView)
        albumArtView.translatesAutoresizingMaskIntoConstraints = false
        albumArtView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive =  true
        albumArtView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        albumArtView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.5).isActive = true
        albumArtView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.8).isActive = true
    }
    
    private func setup(titleView: UIView) {
        contentView.addSubview(titleView)
        titleView.translatesAutoresizingMaskIntoConstraints = false
        titleView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: TopPodcastCellConstants.labelHeightMultiplier).isActive = true
        titleView.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        titleView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        titleView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
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
}
