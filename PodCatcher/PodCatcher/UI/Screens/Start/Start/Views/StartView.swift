import UIKit

final class StartView: UIView {
    
    weak var delegate: StartViewDelegate?
    
    // MARK: - UI Properties
    
    private var titleLabel: UILabel = {
        let title = UILabel()
        title.isHidden = true
        title.textAlignment = .center
        title.font = UIFont(name: "AvenirNext-Medium", size: 20)!
        return title
    }()
    
    private var logoView: UIImageView = {
        let logoView = UIImageView()
        logoView.image = #imageLiteral(resourceName: "pod-logo-white")
        return logoView
    }()
    
    private var guestUserButton: UIButton = {
        let button = UIButton()
        let buttonImage = #imageLiteral(resourceName: "button-background")
        button.setTitle("CONTINUE", for: .normal)
        button.setBackgroundImage(buttonImage, for: .normal)
        return button
    }()
    
    private var userLoginButton: UIButton = {
        let button = UIButton()
        let buttonImage = #imageLiteral(resourceName: "button-background")
        button.setTitle("LOG IN", for: .normal)
        button.setBackgroundImage(buttonImage, for: .normal)
        return button
    }()

    private var createAccountButton: UIButton = {
        let createAccount = UIButton()
        var text = "Don't have an account?"
        var attributes = [NSFontAttributeName : UIFont.systemFont(ofSize: 14, weight: UIFontWeightLight), NSForegroundColorAttributeName : UIColor.white,NSUnderlineStyleAttributeName : 1] as [String : Any]
        var attributedString = NSMutableAttributedString(string:"")
        let buttonTitleStr = NSMutableAttributedString(string:"Don't have an account?", attributes: attributes)
        attributedString.append(buttonTitleStr)
        createAccount.setAttributedTitle(attributedString, for: .normal)
        return createAccount
    }()
    
    // MARK: - Configuration Methods
    
    override func layoutSubviews() {
        CALayer.createGradientLayer(with: [UIColor(red:0.94, green:0.31, blue:0.81, alpha:1.0).cgColor, UIColor(red:0.32, green:0.13, blue:0.70, alpha:1.0).cgColor], layer: layer, bounds: bounds)
        
        super.layoutSubviews()
        setupElements()
        titleLabel.text = "Get started!"
        setupSelectors()
    }
    
    private func setupElements() {
        setup(titleLabel: titleLabel)
        setup(logoView: logoView)
        setup(guestUserButton: guestUserButton)
        guestUserButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: UIFontWeightMedium)
        guestUserButton.alpha = 0.8
        setup(loginButton: userLoginButton)
        userLoginButton.alpha = 0.8
        userLoginButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: UIFontWeightMedium)
        setup(createAccountButton: createAccountButton)
        createAccountButton.alpha = 0.8
        createAccountButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: UIFontWeightBold)
    }
    
    private func setupSelectors() {
        createAccountButton.addTarget(self, action: #selector(createAccountButtonTapped), for: .touchUpInside)
        guestUserButton.addTarget(self, action: #selector(guestUserButtonTapped), for: .touchUpInside)
        userLoginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
    }
    
    func guestUserButtonTapped() {
        delegate?.continueAsGuestTapped()
    }
    
    func createAccountButtonTapped() {
        delegate?.createAccountTapped()
    }
    
    func loginButtonTapped() {
        delegate?.loginTapped()
    }
    
    private func setup(logoView: UIImageView) {
        addSubview(logoView)
        logoView.translatesAutoresizingMaskIntoConstraints = false
        logoView.translatesAutoresizingMaskIntoConstraints = false
        logoView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        logoView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: StartViewConstants.logoViewCenterYOffset).isActive = true
        logoView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.6).isActive = true
        logoView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.08).isActive = true
    }
    
    private func sharedLayout(view: UIView) {
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        view.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        view.heightAnchor.constraint(equalTo: heightAnchor, multiplier: StartViewConstants.sharedLayoutHeightMultiplier).isActive = true
    }
    
    private func setup(titleLabel: UILabel) {
        sharedLayout(view: titleLabel)
        titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: StartViewConstants.titleLabelCenterYOffset).isActive = true
    }
    
    private func setup(guestUserButton: UIButton) {
        sharedLayout(view: guestUserButton)
        guestUserButton.topAnchor.constraint(equalTo: logoView.bottomAnchor, constant: StartViewConstants.guestUserButtonBottomOffset).isActive = true
    }
    
    private func setup(loginButton: UIButton) {
        sharedLayout(view: loginButton)
        loginButton.topAnchor.constraint(equalTo: guestUserButton.bottomAnchor, constant: StartViewConstants.loginButtonBottomOffset).isActive = true
    }
    
    private func setup(createAccountButton: UIButton) {
        sharedLayout(view: createAccountButton)
        createAccountButton.topAnchor.constraint(equalTo: userLoginButton.bottomAnchor, constant: StartViewConstants.createAccountButtonTopOffset).isActive = true
    }
}
