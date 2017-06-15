import UIKit

class PreferencesView: UIView {
    
    weak var delegate: PreferencesViewDelegate?
    
    // MARK: - UI Properties
    
    var moreMenuButton: UIButton = {
        var moreMenuButton = UIButton()
        moreMenuButton.setImage(#imageLiteral(resourceName: "more-button-white"), for: .normal)
        return moreMenuButton
    }()
    
    var addTagButton: UIButton = {
        var addTagButton = UIButton()
       // addTagButton.setImage(#imageLiteral(resourceName: "circleaddwhite"), for: .normal)
        return addTagButton
    }()
    
    // MARK: - Configuration Methods
    
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
        moreButton.heightAnchor.constraint(equalTo: heightAnchor, multiplier: PreferencesViewConstants.tagButtonHeightMultiplier).isActive = true
        moreButton.rightAnchor.constraint(equalTo: rightAnchor, constant: PreferencesViewConstants.moreButtonRightOffset).isActive = true
    }
    
    func setup(addTagButton: UIButton) {
        addSubview(addTagButton)
        addTagButton.translatesAutoresizingMaskIntoConstraints = false
        addTagButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        addTagButton.heightAnchor.constraint(equalTo: heightAnchor, multiplier: PreferencesViewConstants.tagButtonHeightMultiplier).isActive = true
        addTagButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier:  PreferencesViewConstants.tagButtonWidthMultiplier).isActive = true
        addTagButton.leftAnchor.constraint(equalTo: leftAnchor, constant: PreferencesViewConstants.tagButtonLeftOffset).isActive = true
    }
    
    func moreButtonTapped() {
        delegate?.moreButtonTapped(tapped: true)
    }
    
    func addTagButtonTapped() {
        delegate?.addTagButtonTapped(tapped: true)
    }
}
