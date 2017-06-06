import UIKit

class PreferencesView: UIView {
    
    weak var delegate: PreferencesViewDelegate?
    
    var moreMenuButton: UIButton = {
        var moreMenuButton = UIButton()
        moreMenuButton.setImage(#imageLiteral(resourceName: "morebutton"), for: .normal)
        return moreMenuButton
    }()
    
    var addTagButton: UIButton = {
        var addTagButton = UIButton()
        addTagButton.setImage(#imageLiteral(resourceName: "circleaddwhite"), for: .normal)
        return addTagButton
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupConstraints()
        moreMenuButton.addTarget(self, action: #selector(moreButtonTapped), for: .touchUpInside)
        addTagButton.addTarget(self, action: #selector(addTagButtonTapped), for: .touchUpInside)
        backgroundColor = .darkGray
    }
    
    func setupConstraints() {
        setup(moreButton: moreMenuButton)
        setup(addTagButton: addTagButton)
    }
    
    func setup(moreButton: UIButton) {
        addSubview(moreButton)
        moreButton.translatesAutoresizingMaskIntoConstraints = false
        moreButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        moreButton.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5).isActive = true
        moreButton.rightAnchor.constraint(equalTo: rightAnchor, constant: UIScreen.main.bounds.width * -0.1).isActive = true
    }
    
    func setup(addTagButton: UIButton) {
        addSubview(addTagButton)
        addTagButton.translatesAutoresizingMaskIntoConstraints = false
        addTagButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        addTagButton.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5).isActive = true
        addTagButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier:  0.06).isActive = true
        addTagButton.leftAnchor.constraint(equalTo: leftAnchor, constant: UIScreen.main.bounds.width * 0.1).isActive = true
    }
    
    func moreButtonTapped() {
        delegate?.moreButtonTapped(tapped: true)
    }
    
    func addTagButtonTapped() {
        delegate?.addTagButtonTapped(tapped: true)
    }
}
