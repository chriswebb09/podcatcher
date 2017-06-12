import UIKit

class PillView: UIView {
    
    var tagLabel: UILabel = {
        var tagLabel = UILabel()
        tagLabel.font = UIFont(name: "Avenir-Book", size: 12)!
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
        backgroundColor = .green
        layer.cornerRadius = 12
    }
}
