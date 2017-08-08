import UIKit

final class StartView: UIView {
    
    weak var delegate: StartViewDelegate?
    
    // MARK: - UI Properties
    
    private var logoView: UIImageView = {
        let logoView = UIImageView()
        logoView.image = #imageLiteral(resourceName: "pod-logo-white")
        return logoView
    }()
    
    private var guestUserButton: UIButton = {
        let button = UIButton()
        let buttonImage = #imageLiteral(resourceName: "button-background")
        button.setTitle("GET STARTED", for: .normal)
        button.setBackgroundImage(buttonImage, for: .normal)
        return button
    }()
    
    // MARK: - Configuration Methods
    
    override func layoutSubviews() {
        super.layoutSubviews()
        CALayer.createGradientLayer(with: [UIColor(red:0.94, green:0.31, blue:0.81, alpha:1.0).cgColor,
                                           UIColor(red:0.32, green:0.13, blue:0.70, alpha:1.0).cgColor], layer: layer, bounds: bounds)
        setupElements()
        setupSelectors()
    }
    
    private func setupElements() {
        setup(logoView: logoView)
        setup(guestUserButton: guestUserButton)
        guestUserButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: UIFontWeightMedium)
        guestUserButton.alpha = 0.8
    }
    
    private func setupSelectors() {
        guestUserButton.addTarget(self, action: #selector(guestUserButtonTapped), for: .touchUpInside)
    }
    
    @objc func guestUserButtonTapped() {
        delegate?.continueAsGuestTapped()
    }
    
    private func setup(logoView: UIImageView) {
        addSubview(logoView)
        logoView.translatesAutoresizingMaskIntoConstraints = false
        logoView.translatesAutoresizingMaskIntoConstraints = false
        logoView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        logoView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: UIScreen.main.bounds.height * -0.15).isActive = true
        logoView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.72).isActive = true
        logoView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.1).isActive = true
    }
    
    private func sharedLayout(view: UIView) {
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        view.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        view.heightAnchor.constraint(equalTo: heightAnchor, multiplier:  0.1).isActive = true
    }
    
    private func setup(guestUserButton: UIButton) {
        sharedLayout(view: guestUserButton)
        guestUserButton.topAnchor.constraint(equalTo: logoView.bottomAnchor, constant: UIScreen.main.bounds.height * 0.12).isActive = true
    }
}
