import UIKit

protocol GuestUserViewDelegate: class {
    func signIntoAccount(tapped: Bool)
}

class GuestUserView: UIView {
    
    weak var delegate: GuestUserViewDelegate?
    
    private var infoLabel: UILabel = {
        let infoLabel = UILabel.setupInfoLabel()
        infoLabel.text = "Sign in to customize settings!"
        infoLabel.isUserInteractionEnabled = true
        return infoLabel
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setup(infoLabel: infoLabel)
        let tap = UITapGestureRecognizer(target: self, action: #selector(goToStart))
        infoLabel.addGestureRecognizer(tap)
    }
    
    func configure() {
        layoutSubviews()
    }
    
    private func setup(infoLabel: UILabel) {
        addSubview(infoLabel)
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        infoLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: EmptyViewConstants.musicIconWidthMutliplier).isActive = true
        infoLabel.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        infoLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        infoLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: UIScreen.main.bounds.height * -0.2).isActive = true
    }
    
    func goToStart() {
        delegate?.signIntoAccount(tapped: true)
    }
}
