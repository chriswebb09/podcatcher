import UIKit

class TextFieldExtension: UITextField {
    
    // Sets textfield input to + 10 inset on origin x value
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + 12,
                      y: bounds.origin.y,
                      width: bounds.width + 12,
                      height: bounds.height)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + 12,
                      y: bounds.origin.y,
                      width: bounds.width + 12,
                      height: bounds.height)
    }
}

final class EntryView: UIView {
    
    // Input for playlist name
    
    var entryField: TextFieldExtension = {
        var entryField = TextFieldExtension()
        entryField.layer.borderColor = Colors.brightHighlight.cgColor
        entryField.layer.cornerRadius = DetailViewConstants.largeCornerRadius
        entryField.layer.borderWidth = DetailViewConstants.borderWidth
        entryField.placeholder = "Create a new playlist!"
        entryField.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.thin)
        return entryField
    }()
    
    private var titleLabel: UILabel = {
        var titleLabel = UILabel()
        titleLabel.backgroundColor = Colors.brightHighlight
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.font =  UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.regular)
        return titleLabel
    }()
    
    private var detailsTextView: UITextView = {
        var detailsTextView = UITextView()
        detailsTextView.sizeToFit()
        detailsTextView.textAlignment = .center
        detailsTextView.isScrollEnabled = true
        return detailsTextView
    }()
    
    let doneButton: UIButton = {
        var button = UIButton()
        button.tintColor = .white
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(Colors.brightHighlight, for: .normal)
        button.setTitle("Done", for: .normal)
        button.layer.borderColor = Colors.brightHighlight.cgColor
        button.layer.borderWidth = EntryViewConstants.borderWidth
        if let popTitle = button.titleLabel {
            popTitle.font =  UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.regular)
        }
        return button
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        isUserInteractionEnabled = true
        backgroundColor = UIColor.white
        configureShadow(for: layer)
        layer.borderWidth = EntryViewConstants.borderWidth
        layer.borderColor = Colors.brightHighlight.cgColor
    }
    
    private func configureShadow(for layer: CALayer) {
        layer.cornerRadius = DetailViewConstants.cornerRadius
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOpacity = DetailViewConstants.shadowOpacity
        layer.masksToBounds = true
        layer.shadowPath = UIBezierPath(roundedRect:bounds, cornerRadius:layer.cornerRadius).cgPath
    }
    
    func configureView() {
        titleLabel.text = "New Playlist"
        layoutSubviews()
        setupConstraints()
    }
    
    private func setup(entryField: UITextField) {
        addSubview(entryField)
        entryField.translatesAutoresizingMaskIntoConstraints = false
        entryField.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        entryField.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        entryField.heightAnchor.constraint(equalTo: heightAnchor, multiplier: EntryViewConstants.entryFieldHeightMultiplier).isActive = true
        entryField.widthAnchor.constraint(equalTo: widthAnchor, multiplier: DetailViewConstants.fieldWidth).isActive = true
    }
    
    private func setup(titleLabel: UILabel) {
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        titleLabel.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        titleLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: DetailViewConstants.heightMultiplier).isActive = true
    }
    
    private func setup(doneButton: UIButton) {
        addSubview(doneButton)
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        doneButton.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        doneButton.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        doneButton.heightAnchor.constraint(equalTo: heightAnchor, multiplier: DetailViewConstants.heightMultiplier).isActive = true
        doneButton.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
    }
    
    private func setupConstraints() {
        setup(entryField: entryField)
        setup(titleLabel: titleLabel)
        setup(doneButton: doneButton)
    }
}
