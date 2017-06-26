import UIKit

final internal class TrackCell: UICollectionViewCell {
    
    private var viewModel: TrackCellViewModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            albumArtView.downloadImage(url: viewModel.albumImageUrl)
        }
    }
    
    private var albumArtView: UIImageView = {
        var album = UIImageView()
        return album
    }()
    
    // Cell shadow
    
    private func setShadow() {
        layer.setCellShadow(contentView: contentView)
        let path =  UIBezierPath(roundedRect: bounds, cornerRadius: contentView.layer.cornerRadius)
        layer.shadowPath = path.cgPath
    }
    
    func configureCell(with model: TrackCellViewModel, withTime: Double) {
        alpha = 0
        viewModel  = model
        layoutSubviews()
        UIView.animate(withDuration: withTime) {
            self.alpha = 1
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        viewConfigurations()
    }
    
    // MARK: View setup methods
    
    private func viewConfigurations() {
        setShadow()
        setupAlbumArt(albumArtView: albumArtView)
    }
    
    private func setupAlbumArt(albumArtView: UIImageView) {
        contentView.addSubview(albumArtView)
        albumArtView.translatesAutoresizingMaskIntoConstraints = false
        albumArtView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: TrackCellConstants.albumHeightMultiplier).isActive = true
        albumArtView.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        albumArtView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
    }
}
