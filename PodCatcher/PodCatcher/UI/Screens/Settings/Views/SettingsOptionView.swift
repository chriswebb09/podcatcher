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
        backgroundColor = UIColor(red:0.92, green:0.32, blue:0.33, alpha:1.0)
        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = 1
        isUserInteractionEnabled = true
        
    }
    
    func setup(nameLabel: UILabel) {
        addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        nameLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        nameLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.7).isActive = true
        nameLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.7).isActive = true
    }
}
