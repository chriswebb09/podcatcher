import UIKit

final class PlaylistCell: UITableViewCell, Reusable {
    
    static let reuseIdentifier = "PlaylistCell"
    
    var mode: PlaylistCellMode = .select {
        didSet {
            switch mode {
            case .select:
                deleteImageView.alpha = 1
                let image = #imageLiteral(resourceName: "circle-play").withRenderingMode(.alwaysTemplate)
                deleteImageView.image = image
                deleteImageView.tintColor = .darkGray
            case .delete:
                deleteImageView.alpha = 0.8
                let image = #imageLiteral(resourceName: "circle-x").withRenderingMode(.alwaysTemplate)
                deleteImageView.image = image
                deleteImageView.tintColor = UIColor(red:1.00, green:0.41, blue:0.41, alpha:1.0)
            }
        }
    }
    
    var albumArtView: UIImageView = {
        var album = UIImageView()
        return album
    }()
    
    var separatorView: UIView = {
        let separatorView = UIView()
        separatorView.backgroundColor = .clear
        return separatorView
    }()
    
    var titleLabel: UILabel = {
        let title = UILabel()
        title.textColor = .black
        title.font = Style.Font.PlaylistCell.title
            //UIFont(name: "AvenirNext-Regular", size: 17)
        title.textAlignment = .left
        title.numberOfLines = 0
        return title
    }()
    
    var deleteImageView: UIImageView = {
        let delete = UIImageView()
        return delete
    }()
    
    var numberOfItemsLabel: UILabel = {
        let numberOfItems = UILabel()
        numberOfItems.textColor = .black
        numberOfItems.font = Style.Font.PlaylistCell.items
            //UIFont(name: "AvenirNext-UltraLight", size: 14)
        numberOfItems.textAlignment = .left
        numberOfItems.numberOfLines = 0
        return numberOfItems
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setup(titleLabel: titleLabel)
        setup(numberOfItemsLabel: numberOfItemsLabel)
        setup(albumArtView: albumArtView)
        setup(deleteImageView: deleteImageView)
        selectionStyle = .none
        albumArtView.layer.setCellShadow(contentView: self)
        setupSeparator()
    }
    
    private func setShadow() {
        layer.setCellShadow(contentView: contentView)
        let path =  UIBezierPath(roundedRect: bounds, cornerRadius: contentView.layer.cornerRadius)
        layer.shadowPath = path.cgPath
    }
    
    func configure(image: UIImage, title: String, subtitle: String?, mode: PlaylistCellMode) {
        setShadow()
        self.mode = mode
        self.albumArtView.image = image
        self.titleLabel.text = title
        if let subtitle = subtitle {
            self.numberOfItemsLabel.text = subtitle
        } else {
            self.numberOfItemsLabel.text = "Podcasts"
        }
    }
    
    func setupShadow() {
        DispatchQueue.main.async {
            let shadowOffset = CGSize(width:-0.45, height: 0.2)
            let shadowRadius: CGFloat = 1.0
            let shadowOpacity: Float = 0.4
            self.contentView.layer.shadowRadius = shadowRadius
            self.contentView.layer.shadowOffset = shadowOffset
            self.contentView.layer.shadowOpacity = shadowOpacity
        }
    }
    
    func setup(titleLabel: UILabel) {
        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 11, *) {
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 10).isActive = true
        } else {
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: contentView.bounds.width * 0.13).isActive = true
        }
        
        titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: contentView.bounds.height * -0.1).isActive = true
        titleLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.25).isActive = true
        titleLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.3).isActive = true
    }
    
    func setup(numberOfItemsLabel: UILabel) {
        contentView.addSubview(numberOfItemsLabel)
        numberOfItemsLabel.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 11, *) {
            numberOfItemsLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 10).isActive = true
        } else {
            numberOfItemsLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: contentView.bounds.width * 0.13).isActive = true
        }
        numberOfItemsLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: contentView.bounds.height * 0.02).isActive = true
        numberOfItemsLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.25).isActive = true
        numberOfItemsLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.3).isActive = true
    }
    
    private func setup(albumArtView: UIImageView) {
        contentView.addSubview(albumArtView)
        albumArtView.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 11, *) {
            albumArtView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: contentView.bounds.width * 0.07).isActive = true
            albumArtView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
            albumArtView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.7).isActive = true
            albumArtView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.2).isActive = true
        } else {
            albumArtView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: contentView.bounds.width * 0.04).isActive = true
            albumArtView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
            albumArtView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.7).isActive = true
            albumArtView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.28).isActive = true
        }
    }
    
    func setup(deleteImageView: UIImageView) {
        contentView.addSubview(deleteImageView)
        deleteImageView.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 11, *) {
            deleteImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.06).isActive = true
            deleteImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.22).isActive = true
            deleteImageView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: contentView.bounds.width * -0.05).isActive = true
        } else {
            deleteImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.08).isActive = true
            deleteImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.26).isActive = true
            deleteImageView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: contentView.bounds.width * -0.04).isActive = true
        }
        contentView.addConstraint(NSLayoutConstraint(item: deleteImageView,
                                                     attribute: .centerY,
                                                     relatedBy: .equal,
                                                     toItem: contentView,
                                                     attribute: .centerY,
                                                     multiplier: 1.0,
                                                     constant: 0.0))
    }
    
    func setupSeparator() {
        setup(separatorView: separatorView)
        DispatchQueue.main.async {
            self.albumArtView.layer.cornerRadius = 4
            self.albumArtView.layer.borderWidth = 0.5
            let containerLayer = CALayer()
            containerLayer.shadowColor = UIColor.darkText.cgColor
            containerLayer.shadowRadius = 2
            containerLayer.shadowOffset = CGSize(width: 1, height: 1)
            containerLayer.shadowOpacity = 0.6
            self.albumArtView.layer.masksToBounds = true
            containerLayer.addSublayer(self.albumArtView.layer)
            self.layer.addSublayer(containerLayer)
        }
    }
    
    func setup(separatorView: UIView) {
        contentView.addSubview(separatorView)
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            separatorView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.01),
            separatorView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            separatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
            ])
    }
}
