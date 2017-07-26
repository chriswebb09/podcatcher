import UIKit

class SettingCell: UITableViewCell, Reusable {
    
    weak var delegate: SettingCellDelegate?
    
    static let reuseIdentifier = "SettingCell"
    
    var titleLabel: UILabel = {
        let title = UILabel()
        title.textColor = .black
        title.font = UIFont.systemFont(ofSize: 16, weight: UIFontWeightLight)
        title.textAlignment = .center
        title.numberOfLines = 0
        return title
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let tap = UITapGestureRecognizer(target: self, action: #selector(onTap))
        addGestureRecognizer(tap)
        contentView.layer.borderWidth = 1
        setup(titleLabel: titleLabel)
        selectionStyle = .none
    }
    
    func onTap() {
        guard let label = titleLabel.text else { return }
        delegate?.cellTapped(with: label)
    }
    
    func setup(titleLabel: UILabel) {
        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo:  contentView.centerYAnchor).isActive = true
        titleLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor).isActive = true
        titleLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.6).isActive = true
    }
}
