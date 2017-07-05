import UIKit

final class LoginView: UIView {
    
    
    var viewHeightConstraint: NSLayoutConstraint!
    
    
    weak var delegate: LoginViewDelegate?
    
    var model: LoginViewModel! {
        didSet {
            submitButton.isEnabled = model.validContent
            submitButton.titleLabel?.textColor = model.buttonColor
        }
    }
    
    var backgroundView = UIView()
    
    // MARK: - UI Elements
    
    var emailField: UITextField = {
        var usernameField = UnderlineTextField()
        usernameField.placeholder = "Email"
        return usernameField
    }()
    
    var passwordField: UITextField = {
        var passwordField = UnderlineTextField()
        passwordField.isSecureTextEntry = true
        passwordField.setupPasswordField()
        return passwordField
    }()
    
    var submitButton: UIButton = {
        let button = UIButton()
        let buttonImage = #imageLiteral(resourceName: "button-background")
        button.setTitle("SIGN IN", for: .normal)
        button.setBackgroundImage(buttonImage, for: .normal)
        return button
    }()
    
    var loginFacebookButton: UIButton = {
        let button = UIButton()
        let buttonImage = #imageLiteral(resourceName: "button-background").withRenderingMode(.alwaysTemplate)
        button.setTitle("SIGN IN WITH FACEBOOK", for: .normal)
        button.imageView?.tintColor = UIColor(red:0.23, green:0.35, blue:0.60, alpha:1.0)
        button.imageView?.alpha = 0.3
        button.setBackgroundImage(buttonImage, for: .normal)
        return button
    }()
    
    // MARK: - Configuration Methods
    
    override func layoutSubviews() {
        tag = 1
        super.layoutSubviews()
        backgroundView.frame = UIScreen.main.bounds
        addSubview(backgroundView)
        CALayer.createGradientLayer(with: [UIColor(red:0.94, green:0.31, blue:0.81, alpha:1.0).cgColor, UIColor(red:0.32, green:0.13, blue:0.70, alpha:1.0).cgColor], layer: backgroundView.layer, bounds: UIScreen.main.bounds)
        let passwordField = self.passwordField as! UnderlineTextField
        self.emailField.delegate = self
        passwordField.delegate = self
        passwordField.setupPasswordField()
        passwordField.setup()
        let emailField = self.emailField as! UnderlineTextField
        emailField.setupEmailField()
        emailField.setup()
        emailField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        passwordField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        setup(emailField: emailField)
        setup(passwordField: passwordField)
        setup(submitButton: submitButton)
        setup(loginFacebookButton: loginFacebookButton)
        submitButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: UIFontWeightMedium)
        submitButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        emailField.autocorrectionType = .no
        backgroundColor = .white
        loginFacebookButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: UIFontWeightMedium)
    }
    
    func configure(model: LoginViewModel) {
        self.model = model
        
        submitButton.isEnabled = true
        emailField.text = "Link@link.com"
        passwordField.text = "123456"
        submitButton.isEnabled = true
    }
    
    private func sharedLayout(view: UIView) {
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        view.heightAnchor.constraint(equalTo: heightAnchor, multiplier: LoginViewConstants.sharedLayoutHeightMultiplier).isActive = true
        view.widthAnchor.constraint(equalTo: widthAnchor, multiplier: LoginViewConstants.sharedLayoutWidthMultiplier).isActive = true
    }
    
    private func setup(emailField: UITextField) {
        sharedLayout(view: emailField)
        emailField.topAnchor.constraint(equalTo: topAnchor, constant: LoginViewConstants.usernameFieldTopOffset).isActive = true
    }
    
    private func setup(passwordField: UITextField) {
        sharedLayout(view: passwordField)
        passwordField.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: LoginViewConstants.passwordFieldTopOffset).isActive = true
    }
    
    private func setup(submitButton: UIButton) {
        addSubview(submitButton)
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        submitButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        submitButton.heightAnchor.constraint(equalTo: heightAnchor, multiplier: LoginViewConstants.sharedLayoutHeightMultiplier).isActive = true
        submitButton.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        submitButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: LoginViewConstants.submitButtonTopOffset).isActive = true
    }
    
    private func setup(loginFacebookButton: UIButton) {
        addSubview(loginFacebookButton)
        loginFacebookButton.translatesAutoresizingMaskIntoConstraints = false
        loginFacebookButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        loginFacebookButton.heightAnchor.constraint(equalTo: heightAnchor, multiplier: LoginViewConstants.sharedLayoutHeightMultiplier).isActive = true
        loginFacebookButton.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        loginFacebookButton.topAnchor.constraint(equalTo: submitButton.bottomAnchor, constant: LoginViewConstants.facebookButtonTopOffset - 80).isActive = true
    }
    
    func loginButtonTapped() {
        guard let username = emailField.text, let password = passwordField.text else { return }
        delegate?.userEntryDataSubmitted(with: username, and: password)
    }
}