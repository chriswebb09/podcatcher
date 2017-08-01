import UIKit

protocol PreferencesViewDelegate: class {
    func moreButton(tapped: Bool)
    func addTagButton(tapped: Bool)
}

final class PreferencesView: UIView {
    
    weak var delegate: PreferencesViewDelegate?
    
    // MARK: - UI Properties
    
    var moreMenuButton: UIButton = {
        var moreMenuButton = UIButton()
        moreMenuButton.setImage(#imageLiteral(resourceName: "more-button-white"), for: .normal)
        return moreMenuButton
    }()
    
    // MARK: - Configuration Methods
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupConstraints()
        moreMenuButton.addTarget(self, action: #selector(moreButton(tapped:)), for: .touchUpInside)
        backgroundColor = .lightGray
    }
    
    func setupConstraints() {
        setup(moreButton: moreMenuButton)
    }
    
    func setup(moreButton: UIButton) {
        addSubview(moreButton)
        moreButton.translatesAutoresizingMaskIntoConstraints = false
        moreButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        moreButton.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        moreButton.rightAnchor.constraint(equalTo: rightAnchor, constant: UIScreen.main.bounds.width * -0.1).isActive = true
    }
    
    @objc func moreButton(tapped: Bool) {
        delegate?.moreButton(tapped: tapped)
    }
    
    func addTagButton(tapped: Bool) {
        delegate?.addTagButton(tapped: tapped)
    }
}
