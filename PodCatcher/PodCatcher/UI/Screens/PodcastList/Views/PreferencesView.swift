import UIKit

class PreferencesView: UIView {
    
    var moreMenuButton: UIButton = {
        var moreMenuButton = UIButton()
        moreMenuButton.setImage(#imageLiteral(resourceName: "morebutton"), for: .normal)
        return moreMenuButton
    }()
    
    func setupConstraints() {
        setup(moreButton: moreMenuButton)
    }
    
    func setup(moreButton: UIButton) {
        addSubview(moreButton)
        moreButton.translatesAutoresizingMaskIntoConstraints = false
        moreButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        moreButton.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5).isActive = true
        moreButton.rightAnchor.constraint(equalTo: rightAnchor, constant: UIScreen.main.bounds.width * 0.1).isActive = true
    }
}
