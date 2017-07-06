import UIKit

final class PillView: UIView {
    
    var tagLabel: UILabel = {
        var tagLabel = UILabel()
        tagLabel.font = UIFont(name: "AvenirNext-Regular", size: 10)!
        tagLabel.textColor = .white
        tagLabel.textAlignment = .center
        return tagLabel
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setup(tagLabel: tagLabel)
    }
    
    func setup(tagLabel: UILabel) {
        addSubview(tagLabel)
        tagLabel.translatesAutoresizingMaskIntoConstraints = false
        tagLabel.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        tagLabel.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        tagLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        tagLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    func configure(tag: String) {
        tagLabel.text = tag
        backgroundColor = .mainColor
        layer.cornerRadius = 8
        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = 1
    }
}
