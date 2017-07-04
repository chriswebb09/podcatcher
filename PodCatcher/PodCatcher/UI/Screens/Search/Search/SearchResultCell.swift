import UIKit

class SearchResultCell: UITableViewCell {
    
    static let reuseIdentifier = "SearchResultCell"
    var titleLabel: UILabel = {
        let title = UILabel()
        title.textColor = .black
        title.textAlignment = .center
        return title
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.layer.borderWidth = 1
        setup(titleLabel: titleLabel)
    }
    
    
    func setup(titleLabel: UILabel) {
        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        titleLabel.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        titleLabel.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
    }
}

extension SearchResultCell: Reusable {}
