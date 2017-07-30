import UIKit

enum PlaylistCellMode {
    case select, delete
}

final class PlaylistCell: UITableViewCell, Reusable {
    
    static let reuseIdentifier = "PlaylistCell"
    
    var mode: PlaylistCellMode = .select {
        didSet {
            switch mode {
            case .select:
                deleteImageView.alpha = 0
            case .delete:
                deleteImageView.alpha = 1
            }
        }
    }
    
    var albumArtView: UIImageView = {
        var album = UIImageView()
        return album
    }()
    
    var titleLabel: UILabel = {
        let title = UILabel()
        title.textColor = .black
        title.font = UIFont.systemFont(ofSize: 14, weight: UIFontWeightMedium)
        title.textAlignment = .center
        title.numberOfLines = 0
        return title
    }()
    
    var deleteImageView: UIImageView = {
        let delete = UIImageView()
        let image = #imageLiteral(resourceName: "circle-x").withRenderingMode(.alwaysTemplate)
        delete.image = image
        delete.tintColor = .red
        //delete.tintColor = .white
        return delete
    }()
    
    var numberOfItemsLabel: UILabel = {
        let numberOfItems = UILabel()
        numberOfItems.textColor = .black
        numberOfItems.font = UIFont.systemFont(ofSize: 14, weight: UIFontWeightThin)
        numberOfItems.textAlignment = .center
        numberOfItems.numberOfLines = 0
        return numberOfItems
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.layer.borderWidth = 1
        setup(titleLabel: titleLabel)
        setup(numberOfItemsLabel: numberOfItemsLabel)
        setup(albumArtView: albumArtView)
        setup(deleteImageView: deleteImageView)
        setupShadow()
        selectionStyle = .none
        albumArtView.layer.setCellShadow(contentView: self)
    }
    
    func configure(image: UIImage, title: String, mode: PlaylistCellMode) {
        self.mode = mode
        self.albumArtView.image = image
        self.titleLabel.text = title.uppercased()
        self.numberOfItemsLabel.text = "Podcasts"
    }
    
    func setupShadow() {
        let shadowOffset = CGSize(width:-0.45, height: 0.2)
        let shadowRadius: CGFloat = 1.0
        let shadowOpacity: Float = 0.4
        
        contentView.layer.shadowRadius = shadowRadius
        contentView.layer.shadowOffset = shadowOffset
        contentView.layer.shadowOpacity = shadowOpacity
    }
    
    func setup(titleLabel: UILabel) {
        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: contentView.bounds.width * 0.2).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: contentView.bounds.height * -0.1).isActive = true
        titleLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.25).isActive = true
        titleLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.5).isActive = true
    }
    
    func setup(numberOfItemsLabel: UILabel) {
        contentView.addSubview(numberOfItemsLabel)
        numberOfItemsLabel.translatesAutoresizingMaskIntoConstraints = false
        numberOfItemsLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: contentView.bounds.width * 0.2).isActive = true
        numberOfItemsLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: contentView.bounds.height * 0.01).isActive = true
        numberOfItemsLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.25).isActive = true
        numberOfItemsLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.5).isActive = true
    }
    
    private func setup(albumArtView: UIImageView) {
        contentView.addSubview(albumArtView)
        albumArtView.translatesAutoresizingMaskIntoConstraints = false
        albumArtView.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        albumArtView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        albumArtView.heightAnchor.constraint(equalTo: contentView.heightAnchor).isActive = true
        albumArtView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.35).isActive = true
    }
    
    func setup(deleteImageView: UIImageView) {
        contentView.addSubview(deleteImageView)
        deleteImageView.translatesAutoresizingMaskIntoConstraints = false
        deleteImageView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: contentView.bounds.width * -0.04).isActive = true
        deleteImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 0).isActive = true
        deleteImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.2).isActive = true
        deleteImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.06).isActive = true
    }
}
