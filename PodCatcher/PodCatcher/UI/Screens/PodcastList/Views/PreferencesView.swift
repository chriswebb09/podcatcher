import UIKit

class PreferencesView: UIView {
    
    weak var delegate: PreferencesViewDelegate?
    
    var moreMenuButton: UIButton = {
        var moreMenuButton = UIButton()
        moreMenuButton.setImage(#imageLiteral(resourceName: "morebutton"), for: .normal)
        return moreMenuButton
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupConstraints()
        moreMenuButton.addTarget(self, action: #selector(moreButtonTapped), for: .touchUpInside)
        backgroundColor = .darkGray
    }
    
    func setupConstraints() {
        setup(moreButton: moreMenuButton)
    }
    
    func setup(moreButton: UIButton) {
        addSubview(moreButton)
        moreButton.translatesAutoresizingMaskIntoConstraints = false
        moreButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        moreButton.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5).isActive = true
        moreButton.rightAnchor.constraint(equalTo: rightAnchor, constant: UIScreen.main.bounds.width * -0.1).isActive = true
    }
    
    func moreButtonTapped() {
        delegate?.moreButtonTapped(tapped: true)
    }
}
