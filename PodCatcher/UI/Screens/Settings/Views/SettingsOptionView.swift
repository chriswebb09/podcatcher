import UIKit

class SettingsOptionView: UIView {
    
    private var settingNameLabel: UILabel = {
        let settingName = UILabel()
        settingName.textColor = .white
        settingName.textAlignment = .center
        return settingName
    }()
    
    func set(settingName: String) {
        settingNameLabel.text = settingName
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setup(nameLabel: settingNameLabel)
        backgroundColor = SettingsOptionViewConstants.backgroundColor
        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = SettingsOptionViewConstants.borderWidth
        isUserInteractionEnabled = true
    }
    
    func setup(nameLabel: UILabel) {
        addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        nameLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        nameLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: SettingsOptionViewConstants.nameLabelWidthAnchor).isActive = true
        nameLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: SettingsOptionViewConstants.nameLabelWidthAnchor).isActive = true
    }
}
