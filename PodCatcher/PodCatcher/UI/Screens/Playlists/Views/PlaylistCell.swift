import UIKit

final class PlaylistCell: UITableViewCell {
    
    static let reuseIdentifier = "PlaylistCell"
    
    var albumArtView: UIImageView = {
        var album = UIImageView()
        return album
    }()
    
    var titleLabel: UILabel = {
        let title = UILabel()
        title.textColor = .black
        title.font = UIFont.systemFont(ofSize: 16, weight: UIFontWeightRegular)
        title.textAlignment = .center
        title.numberOfLines = 0
        return title
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.layer.borderWidth = 1
        setup(titleLabel: titleLabel)
        setup(albumArtView: albumArtView)
        selectionStyle = .none
    }
    
    func setup(titleLabel: UILabel) {
        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: contentView.bounds.width * 0.1).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo:  contentView.centerYAnchor).isActive = true
        titleLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor).isActive = true
        titleLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.6).isActive = true
    }
    
    private func setup(albumArtView: UIImageView) {
        contentView.addSubview(albumArtView)
        albumArtView.translatesAutoresizingMaskIntoConstraints = false
        albumArtView.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        albumArtView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        albumArtView.heightAnchor.constraint(equalTo: contentView.heightAnchor).isActive = true
        albumArtView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.25).isActive = true
    }
}

extension PlaylistCell: Reusable {}

import UIKit

struct TrackCellViewModel {
    
    var trackName: String
    var albumImageUrl: URL
    
    init(trackName: String, albumImageUrl: URL) {
        self.trackName = trackName
        self.albumImageUrl = albumImageUrl
    }
}

final internal class TrackCell: UICollectionViewCell {
    
    private var viewModel: TrackCellViewModel? {
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
        trackName.font = UIFont.systemFont(ofSize: 12, weight: UIFontWeightThin)
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
    
    func configureCell(with model: TrackCellViewModel, withTime: Double) {
        viewModel = model
        guard let viewModel = viewModel else { return }
        layer.borderWidth = 1
        contentView.layer.cornerRadius = 3
        layer.borderColor = UIColor.lightText.cgColor
        layoutSubviews()
        contentView.backgroundColor = Colors.offWhite
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
        albumArtView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: contentView.bounds.height * 0.1).isActive = true
        albumArtView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        albumArtView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.65).isActive = true
        albumArtView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.8).isActive = true
    }
    
    private func setup(titleView: UIView) {
        contentView.addSubview(titleView)
        titleView.translatesAutoresizingMaskIntoConstraints = false
        titleView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: TrackCellConstants.labelHeightMultiplier).isActive = true
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
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        albumArtView.image = nil
        trackNameLabel.text = ""
    }
}
