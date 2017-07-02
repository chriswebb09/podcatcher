import UIKit

final class MenuOptionView: UIView {
    
    private var optionLabel: UILabel = {
        let option = UILabel()
        option.textColor = .white
        option.backgroundColor = .clear
        option.font = UIFont(name: "AvenirNext-Medium", size: 15)
        option.textAlignment = .center
        return option
    }()
    
    private var iconView: UIImageView = {
        var icon = UIImageView()
        icon.isHidden = true
        return icon
    }()
    
    func set(with text: String, and icon: UIImage) {
        optionLabel.text = text
        iconView.image = icon
        alpha = 1
    }
    
    func set(title: String) {
        optionLabel.text = title
    }
    
    func set(textColor: UIColor) {
        optionLabel.textColor = textColor
    }
    
    private func setup(label: UILabel) {
        addSubview(optionLabel)
        optionLabel.translatesAutoresizingMaskIntoConstraints = false
        optionLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        optionLabel.centerXAnchor.constraint(equalTo: centerXAnchor, constant: MenuOptionViewConstants.optionLabelCenterXOffset).isActive = true
        optionLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: MenuOptionViewConstants.optionLabelHeightMultiplier).isActive = true
        optionLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: MenuOptionViewConstants.optionLabelWidthMultiplier).isActive = true
    }
    
    private func setup(iconView: UIImageView) {
        addSubview(iconView)
        iconView.translatesAutoresizingMaskIntoConstraints = false
        iconView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        iconView.centerXAnchor.constraint(equalTo: centerXAnchor, constant: MenuOptionViewConstants.iconViewCenterXOffset).isActive = true
        iconView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: MenuOptionViewConstants.iconViewHeightAnchor).isActive = true
        iconView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: MenuOptionViewConstants.iconViewWidthAnchor).isActive = true
    }
    
    func setupConstraints() {
        backgroundColor = .clear
        setup(label: optionLabel)
        setup(iconView: iconView)
    }
}
