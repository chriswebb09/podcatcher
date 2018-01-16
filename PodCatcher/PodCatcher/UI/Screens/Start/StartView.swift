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
        CALayer.createGradientLayer(with: StartViewConstants.gradientColors, layer: layer, bounds: bounds)
        setupElements()
        setupSelectors()
    }
    
    private func setupElements() {
        setup(logoView: logoView)
        setup(guestUserButton: guestUserButton)
        guestUserButton.titleLabel?.font = StartViewConstants.buttonFont
        guestUserButton.alpha = StartViewConstants.buttonAlpha
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
        NSLayoutConstraint.activate([
            logoView.centerXAnchor.constraint(equalTo: centerXAnchor),
            logoView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: StartViewConstants.logoCenterOffset),
            logoView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: StartViewConstants.logoWidthMultiplier),
            logoView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: StartViewConstants.logoHeightMultiplier)
            ])
    }
    
    private func sharedLayout(view: UIView) {
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.centerXAnchor.constraint(equalTo: centerXAnchor),
            view.widthAnchor.constraint(equalTo: widthAnchor),
            view.heightAnchor.constraint(equalTo: heightAnchor, multiplier:  StartViewConstants.logoHeightMultiplier)
            ])
    }
    
    private func setup(guestUserButton: UIButton) {
        sharedLayout(view: guestUserButton)
        guestUserButton.topAnchor.constraint(equalTo: logoView.bottomAnchor, constant: StartViewConstants.buttonTopOffset).isActive = true
    }
}
