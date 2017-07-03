import UIKit

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
    
    private var trackNameLabel: UILabel = {
        var trackName = UILabel()
        trackName.backgroundColor = .white
        trackName.font = TrackCellConstants.smallFont
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
        contentView.backgroundColor = Colors.lightHighlight
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setup(albumArtView: albumArtView)
        setupTrackInfoLabel(trackNameLabel: trackNameLabel)
        viewConfigurations()
    }
    
    // MARK: View setup methods
    
    private func viewConfigurations() {
        setShadow()
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
    
    private func setupTrackInfoLabel(trackNameLabel: UILabel) {
        contentView.addSubview(trackNameLabel)
        trackNameLabel.translatesAutoresizingMaskIntoConstraints = false
        trackNameLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: TrackCellConstants.labelHeightMultiplier).isActive = true
        trackNameLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        trackNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        albumArtView.image = nil
        trackNameLabel.text = "" 
    }
}
