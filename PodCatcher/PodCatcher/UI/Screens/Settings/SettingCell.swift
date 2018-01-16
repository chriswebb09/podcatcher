import UIKit

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
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo:  contentView.centerYAnchor),
            titleLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor),
            titleLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: SettingCellConstants.widthMultiplier)
            ])
    }
}
