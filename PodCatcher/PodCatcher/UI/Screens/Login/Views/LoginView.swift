import UIKit

final class LoginView: UIView {
    
    weak var delegate: LoginViewDelegate?
    
    
    var model: LoginViewModel! {
        didSet {
            submitButton.isEnabled = model.validContent
            submitButton.backgroundColor = model.buttonColor
        }
    }
    
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
    
    fileprivate var submitButton: UIButton = {
        var borderColor = UIColor.lightText.cgColor
        let submitButton = BasicButtonFactory(text: "Sign In", textColor: .white, borderWidth: 2, borderColor: borderColor, backgroundColor: .lightText)
        
        return submitButton.createButton()
    }()
    
    // MARK: - Configuration Methods
    
    override func layoutSubviews() {
        tag = 1
        super.layoutSubviews()
        //CALayer.createGradientLayer(with: [UIColor.white.cgColor, UIColor.lightGray.cgColor], layer: layer, bounds: bounds)
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
        submitButton.layer.cornerRadius = 10
        submitButton.alpha = 0.7
        submitButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        emailField.autocorrectionType = .no
        backgroundColor = .white        
    }
    
    func configure(model: LoginViewModel) {
        self.model = model
        submitButton.isEnabled = true
        emailField.text = "Link@link.com"
        passwordField.text = "123456"
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
        sharedLayout(view: submitButton)
        submitButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: LoginViewConstants.submitButtonTopOffset).isActive = true
    }
    
    func loginButtonTapped() {
        guard let username = emailField.text, let password = passwordField.text else { return }
        delegate?.userEntryDataSubmitted(with: username, and: password)
    }
}
