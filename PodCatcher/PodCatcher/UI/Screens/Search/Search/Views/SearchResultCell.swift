import UIKit

class SearchResultCell: UITableViewCell, Reusable {
    
    static let reuseIdentifier = "SearchResultCell"
    
    var albumArtView: UIImageView = {
        var album = UIImageView()
        album.layer.cornerRadius = 5
        return album
    }()
    
    var titleLabel: UILabel = {
        let title = UILabel()
        title.textColor = .black
        title.font = UIFont.systemFont(ofSize: 13, weight: UIFontWeightMedium)
        title.textAlignment = .center
        title.numberOfLines = 0
        return title
    }()
    
    var separatorView: UIView = {
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
        albumArtView.layer.setCellShadow(contentView: self)
       
    }
    
    func setupSeparator() {
        setup(separatorView: separatorView)
        DispatchQueue.main.async {
            self.albumArtView.layer.cornerRadius = 6
        }
    }
    
    func setupShadow() {
        let shadowOffset = CGSize(width:-0.45, height: 0.2)
        let shadowRadius: CGFloat = 1.0
        let shadowOpacity: Float = 0.4
        contentView.layer.shadowRadius = shadowRadius
        contentView.layer.shadowOffset = shadowOffset
        contentView.layer.shadowOpacity = shadowOpacity
    }
    
    func setup(separatorView: UIView) {
        contentView.addSubview(separatorView)
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        separatorView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.01).isActive = true
        separatorView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.62).isActive = true
        separatorView.rightAnchor.constraint(equalTo: rightAnchor, constant: contentView.bounds.width * -0.03).isActive = true
        separatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    
    func setup(titleLabel: UILabel) {
        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: contentView.bounds.width * 0.18).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo:  contentView.centerYAnchor).isActive = true
        titleLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor).isActive = true
        titleLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.62).isActive = true
    }
    
    private func setup(albumArtView: UIImageView) {
        contentView.addSubview(albumArtView)
        albumArtView.translatesAutoresizingMaskIntoConstraints = false
        albumArtView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: contentView.bounds.width * 0.02).isActive = true
        albumArtView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        albumArtView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.88).isActive = true
        albumArtView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.3).isActive = true
    }
}
