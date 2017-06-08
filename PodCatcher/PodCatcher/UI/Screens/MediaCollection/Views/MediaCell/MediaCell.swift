import UIKit

final class MediaCell: UICollectionViewCell {
    
    fileprivate var viewModel: MediaCellViewModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            trackNameLabel.text = viewModel.trackName
            albumArtView.image = viewModel.albumImageUrl
           // albumArtView.downloadImage(url: viewModel.albumImageUrl)
        }
    }
    
    // MARK: - UI Element Properties
    
    fileprivate var trackNameLabel: UILabel = {
        var trackName = UILabel()
        trackName.backgroundColor = .white
        trackName.font = MediaCellConstants.smallFont
        trackName.textAlignment = .center
        trackName.numberOfLines = 0
        return trackName
    }()
    
    fileprivate var albumArtView: UIImageView = {
        var album = UIImageView()
        return album
    }()
    
    private func setShadow() {
        layer.setCellShadow(contentView: contentView)
        let path =  UIBezierPath(roundedRect: bounds, cornerRadius: contentView.layer.cornerRadius)
        layer.shadowPath = path.cgPath
    }
    
    func configureCell(with model: MediaCellViewModel, withTime: Double) {
        alpha = 0
        viewModel  = model
        albumArtView.image = model.albumImageUrl
        layoutSubviews()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        viewConfigurations()
    }
    
    private func viewConfigurations() {
        setShadow()
        setup(albumArtView: albumArtView)
        setup(trackNameLabel: trackNameLabel)
    }
    
    private func setup(albumArtView: UIImageView) {
        contentView.addSubview(albumArtView)
        albumArtView.translatesAutoresizingMaskIntoConstraints = false
        albumArtView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: MediaCellConstants.albumHeightMultiplier).isActive = true
        albumArtView.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        albumArtView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
    }
    
    private func setup(trackNameLabel: UILabel) {
        contentView.addSubview(trackNameLabel)
        trackNameLabel.translatesAutoresizingMaskIntoConstraints = false
        trackNameLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: MediaCellConstants.labelHeightMultiplier).isActive = true
        trackNameLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        trackNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
}

