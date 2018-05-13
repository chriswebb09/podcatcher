import UIKit

final class SearchResultCell: UITableViewCell, Reusable {
    
    static let reuseIdentifier = "SearchResultCell"
    
    private var albumArtView: UIImageView = {
        var album = UIImageView()
        album.layer.cornerRadius = 5
        return album
    }()
    
    private var titleLabel: UILabel = {
        let title = UILabel()
        title.textColor = .black
        title.font = UIFont(name: "AvenirNext-Regular", size: 12)
        title.textAlignment = .center
        title.numberOfLines = 0
        return title
    }()
    
    private var separatorView: UIView = {
        let separatorView = UIView()
        separatorView.backgroundColor = .lightGray
        return separatorView
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setup(titleLabel: titleLabel)
        setup(albumArtView: albumArtView)
        setupSeparator()
        selectionStyle = .none
    }
    
    func configureCell(with imageUrl: URL, title: String) {
        albumArtView.alpha = 0
        titleLabel.text = title
        albumArtView.image = #imageLiteral(resourceName: "placeholder")
        albumArtView.downloadImage(url: imageUrl)
        UIView.animate(withDuration: 0.02, animations: {
            self.albumArtView.alpha = 1
        })
    }
    
    private func setupSeparator() {
        setup(separatorView: separatorView)
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.albumArtView.layer.cornerRadius = 4
            let containerLayer = CALayer()
            containerLayer.shadowColor = UIColor.darkText.cgColor
            containerLayer.shadowRadius = 1
            containerLayer.shadowOffset = CGSize(width: 0, height: 0)
            containerLayer.shadowOpacity = 0.7
            strongSelf.albumArtView.layer.masksToBounds = true
            containerLayer.addSublayer(strongSelf.albumArtView.layer)
            strongSelf.layer.addSublayer(containerLayer)
        }
    }
    
    private func setupShadow() {
        let shadowOffset = CGSize(width:-0.45, height: 0.2)
        let shadowRadius: CGFloat = 1.0
        let shadowOpacity: Float = 0.3
        contentView.layer.shadowRadius = shadowRadius
        contentView.layer.shadowOffset = shadowOffset
        contentView.layer.shadowOpacity = shadowOpacity
    }
    
    private func setup(separatorView: UIView) {
        contentView.addSubview(separatorView)
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            separatorView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.01),
            separatorView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            separatorView.rightAnchor.constraint(equalTo: rightAnchor),
            separatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
            ])
    }
    
    private func setup(titleLabel: UILabel) {
        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: contentView.bounds.width * 0.16),
            titleLabel.centerYAnchor.constraint(equalTo:  contentView.centerYAnchor),
            titleLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor),
            titleLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.64)
            ])
    }
    
    private func setup(albumArtView: UIImageView) {
        contentView.addSubview(albumArtView)
        albumArtView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            albumArtView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: contentView.bounds.width * 0.02),
            albumArtView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            albumArtView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.88),
            albumArtView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.29)
            ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        albumArtView.image = nil
    }
}
