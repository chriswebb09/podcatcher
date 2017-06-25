import UIKit

final class MediaCell: UICollectionViewCell {
    
    fileprivate var viewModel: MediaCellViewModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            albumArtView.image = viewModel.albumImageUrl
        }
    }
    
    // MARK: - UI Element Properties
    
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
        self.viewModel  = model
        self.albumArtView.image = model.albumImageUrl
        self.layoutSubviews()
        UIView.animate(withDuration: withTime) {
            self.alpha = 1
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        viewConfigurations()
    }
    
    private func viewConfigurations() {
        setShadow()
        setup(albumArtView: albumArtView)
    }
    
    private func setup(albumArtView: UIImageView) {
        contentView.addSubview(albumArtView)
        albumArtView.translatesAutoresizingMaskIntoConstraints = false
        albumArtView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: MediaCellConstants.albumHeightMultiplier).isActive = true
        albumArtView.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        albumArtView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        albumArtView.image = nil
    }
}

