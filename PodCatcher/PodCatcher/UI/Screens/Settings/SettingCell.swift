import UIKit

struct SettingCellConstants {
    static let widthMultiplier: CGFloat = 0.6
    static let titleFont = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.light)
    static let borderWidth: CGFloat = 1
}

final class SettingCell: UITableViewCell, Reusable {
    
    weak var delegate: SettingCellDelegate?
    
    static let reuseIdentifier = "SettingCell"
    
    var titleLabel: UILabel = {
        let title = UILabel()
        title.textColor = .black
        title.font = SettingCellConstants.titleFont
        title.textAlignment = .center
        title.numberOfLines = 0
        return title
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let tap = UITapGestureRecognizer(target: self, action: #selector(onTap))
        addGestureRecognizer(tap)
        contentView.layer.borderWidth = SettingCellConstants.borderWidth
        setup(titleLabel: titleLabel)
        selectionStyle = .none
    }
    
    @objc func onTap() {
        guard let label = titleLabel.text else { return }
        delegate?.cellTapped(with: label)
    }
    
    func setup(titleLabel: UILabel) {
        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo:  contentView.centerYAnchor).isActive = true
        titleLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor).isActive = true
        titleLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: SettingCellConstants.widthMultiplier).isActive = true
    }
}
