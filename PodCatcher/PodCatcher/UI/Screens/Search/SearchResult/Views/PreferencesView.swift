import UIKit

final class PreferencesView: UIView {
    
    weak var delegate: PreferencesViewDelegate?
    
    // MARK: - UI Properties
    
    var moreMenuButton: UIButton = {
        var moreMenuButton = UIButton()
        moreMenuButton.alpha = 0.6
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
        moreButton.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.8).isActive = true
        moreButton.rightAnchor.constraint(equalTo: rightAnchor, constant: UIScreen.main.bounds.width * -0.04).isActive = true
        moreMenuButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.22).isActive = true
    }
    
    @objc func moreButton(tapped: Bool) {
        delegate?.moreButton(tapped: tapped)
    }
    
    func addTagButton(tapped: Bool) {
        delegate?.addTagButton(tapped: tapped)
    }
}
