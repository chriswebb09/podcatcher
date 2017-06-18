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
        logoView.image = #imageLiteral(resourceName: "wavelogo")
      //  logoView.image = #imageLiteral(resourceName: "podcatchlogo")
       // logoView.image =
        return logoView
    }()
    
    private var guestUserButton: UIButton = {
        let guestUser = BasicButtonFactory(text: "Continue As Guest", textColor: .white, borderWidth: StartViewConstants.buttonBorderWidth, borderColor: UIColor.blue.cgColor, backgroundColor: UIColor.mainColor)
        return guestUser.createButton()
    }()
    
    private var userLoginButton: UIButton = {
        let userLogin = LoginButtonFactory(text: "Log in to Account", textColor: .white, buttonBorderWidth: StartViewConstants.buttonBorderWidth, buttonBorderColor: UIColor.blue.cgColor, buttonBackgroundColor: UIColor.mainColor)
        return userLogin.createButton()
    }()
    
    private var createAccountButton: UIButton = {
        let createAccount = UIButton()
        var text = "Don't have an account?"
        
        var attributes = [NSFontAttributeName : UIFont.systemFont(ofSize: 19.0), NSForegroundColorAttributeName : UIColor.white,NSUnderlineStyleAttributeName : 1] as [String : Any]
        var attributedString = NSMutableAttributedString(string:"")
        let buttonTitleStr = NSMutableAttributedString(string:"Don't have an account?", attributes: attributes)
        attributedString.append(buttonTitleStr)
        createAccount.setAttributedTitle(attributedString, for: .normal)
        return createAccount
    }()
    
    // MARK: - Configuration Methods
    
    override func layoutSubviews() {
        CALayer.createGradientLayer(with: [UIColor.white.cgColor, UIColor.gray.cgColor], layer: layer, bounds: bounds)

        super.layoutSubviews()
        setupElements()
        titleLabel.text = "Get started!"
        setupSelectors()
    }
    
    private func setupElements() {
        setup(titleLabel: titleLabel)
        setup(logoView: logoView)
        setup(guestUserButton: guestUserButton)
        guestUserButton.layer.cornerRadius = 10
        setup(loginButton: userLoginButton)
        userLoginButton.layer.cornerRadius = 10
        setup(createAccountButton: createAccountButton)
        createAccountButton.layer.cornerRadius = 10
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
        logoView.widthAnchor.constraint(equalTo: widthAnchor, constant: UIScreen.main.bounds.width * 0.005).isActive = true
        logoView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.08).isActive = true
    }
    
    private func sharedLayout(view: UIView) {
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        view.widthAnchor.constraint(equalTo: widthAnchor, multiplier: StartViewConstants.sharedLayoutWidthMultiplier).isActive = true
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
