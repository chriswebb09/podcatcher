import UIKit

final class MenuOptionView: UIView {
    
    private var optionLabel: UILabel = {
        let option = UILabel()
        option.textColor = .white
        option.backgroundColor = .clear
        option.font = UIFont(name: "Avenir-Book", size: 15)
        option.textAlignment = .right
        return option
    }()
    
    private var iconView: UIImageView = {
        var icon = UIImageView()
        return icon
    }()
    
    func set(with text: String, and icon: UIImage) {
        self.optionLabel.text = text
        self.iconView.image = icon
    }
    
    private func setupOptionLabelConstraints(label: UILabel) {
        addSubview(optionLabel)
        optionLabel.translatesAutoresizingMaskIntoConstraints = false
        optionLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        optionLabel.centerXAnchor.constraint(equalTo: centerXAnchor, constant: UIScreen.main.bounds.width * -0.1).isActive = true
        optionLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5).isActive = true
        optionLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.4).isActive = true
        
    }
    
    private func setupIconViewConstraints(iconView: UIImageView) {
        addSubview(iconView)
        iconView.translatesAutoresizingMaskIntoConstraints = false
        iconView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        iconView.centerXAnchor.constraint(equalTo: centerXAnchor, constant: UIScreen.main.bounds.width * 0.25).isActive = true
        iconView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.35).isActive = true
        iconView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.08).isActive = true
    }
    
    func setupConstraints() {
        backgroundColor = .clear
        setupOptionLabelConstraints(label: optionLabel)
        setupIconViewConstraints(iconView: iconView)
    }
    
}
 
