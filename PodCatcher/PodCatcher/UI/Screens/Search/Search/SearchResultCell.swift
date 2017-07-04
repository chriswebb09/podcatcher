import UIKit

class SearchResultCell: UITableViewCell {
    
    static let reuseIdentifier = "SearchResultCell"
    
    var albumArtView: UIImageView = {
        var album = UIImageView()
        return album
    }()
    
    var titleLabel: UILabel = {
        let title = UILabel()
        title.textColor = .black
        title.font = UIFont.systemFont(ofSize: 14, weight: UIFontWeightThin
        )
        title.textAlignment = .center
        title.numberOfLines = 0
        return title
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.layer.borderWidth = 1
        setup(titleLabel: titleLabel)
        setup(albumArtView: albumArtView)
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

extension SearchResultCell: Reusable {}
