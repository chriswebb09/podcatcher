import UIKit

final class EntryView: UIView {
    
    // Input for playlist name
    
    var entryField: TextFieldExtension = {
        var entryField = TextFieldExtension()
        entryField.layer.borderColor = DetailViewConstants.mainColor.cgColor
        entryField.layer.cornerRadius = DetailViewConstants.largeCornerRadius
        entryField.layer.borderWidth = DetailViewConstants.borderWidth
        entryField.placeholder = "Add a new tag!"
        entryField.font = UIFont(name: "Avenir-Book", size: 20)!
        return entryField
    }()
    
    private var titleLabel: UILabel = {
        var titleLabel = UILabel()
        titleLabel.backgroundColor = DetailViewConstants.mainColor
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.font = DetailViewConstants.titleFont
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
        button.setTitleColor(PlaylistViewControllerConstants.mainColor, for: .normal)
        button.setTitle("Done", for: .normal)
        button.layer.borderColor = PlaylistViewControllerConstants.mainColor.cgColor
        button.layer.borderWidth = 1.5
        if let popTitle = button.titleLabel, let font = UIFont(name: "Avenir-Book", size: 20) {
            popTitle.font = font
        }
        return button
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        isUserInteractionEnabled = true
        backgroundColor = UIColor.white
        configureShadow(for: layer)
        layer.borderWidth = 1.5
        layer.borderColor = PlaylistViewControllerConstants.mainColor.cgColor
    }
    
    private func configureShadow(for layer: CALayer) {
        layer.cornerRadius = DetailViewConstants.cornerRadius
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOpacity = DetailViewConstants.shadowOpacity
        layer.masksToBounds = true
        layer.shadowPath = UIBezierPath(roundedRect:bounds, cornerRadius:layer.cornerRadius).cgPath
    }
    
    func configureView() {
        titleLabel.text = "Add A Tag"
        layoutSubviews()
        setupConstraints()
    }
    
    private func setup(entryField: UITextField) {
        addSubview(entryField)
        entryField.translatesAutoresizingMaskIntoConstraints = false
        entryField.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        entryField.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        entryField.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.14).isActive = true
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
