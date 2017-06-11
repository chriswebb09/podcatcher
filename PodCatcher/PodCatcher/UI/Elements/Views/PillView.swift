import UIKit

class PillView: UIView {
    
    var tagLabel: UILabel = {
        var tagLabel = UILabel()
        return tagLabel
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setup(tagLabel: tagLabel)
    }
    
    func setup(tagLabel: UILabel) {
        addSubview(tagLabel)
        tagLabel.translatesAutoresizingMaskIntoConstraints = false
        tagLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        tagLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    func configure(tag: String) {
        tagLabel.text = tag 
    }
}
