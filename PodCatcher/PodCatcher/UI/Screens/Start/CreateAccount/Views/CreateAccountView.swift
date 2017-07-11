import UIKit

final class CreateAccountView: UIView {
    
    weak var delegate: CreateAccountViewDelegate?
    
    // MARK: - UI Elements
    
    var backgroundView = UIView()
    
    var navBar: UIView = {
        let navBar = UIView()
        return navBar
    }()
    
    private var navigateBackButton: UIButton = {
        var backButton = UIButton()
        var buttonImage = #imageLiteral(resourceName: "back").withRenderingMode(.alwaysTemplate)
        backButton.setImage(buttonImage, for: .normal)
        backButton.tintColor = .white
        return backButton
    }()
    
    
    var emailField: UITextField = {
        var usernameField = UnderlineTextField()
        usernameField.placeholder = "Email"
        return usernameField
    }()
    
    var confirmEmailField: UITextField = {
        var usernameField = UnderlineTextField()
        usernameField.placeholder = "Email"
        return usernameField
    }()
    
    private var passwordField: UITextField = {
        var passwordField = UnderlineTextField()
        passwordField.isSecureTextEntry = true
        return passwordField
    }()
    
    fileprivate var submitButton: UIButton = {
        let button = UIButton()
        let buttonImage = #imageLiteral(resourceName: "button-background")
        button.setTitle("SUBMIT", for: .normal)
        button.setBackgroundImage(buttonImage, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: UIFontWeightMedium)
        return button
    }()
    
    // MARK: - Configuration Methods
    
    override func layoutSubviews() {
        tag = 1
        super.layoutSubviews()
        backgroundView.frame = UIScreen.main.bounds
        addSubview(backgroundView)
        CALayer.createGradientLayer(with: [UIColor(red:0.94, green:0.31, blue:0.81, alpha:1.0).cgColor, UIColor(red:0.32, green:0.13, blue:0.70, alpha:1.0).cgColor], layer: backgroundView.layer, bounds: bounds)
        let emailField = self.emailField as! UnderlineTextField
        let confirmEmailField = self.confirmEmailField as! UnderlineTextField
        let passwordField = self.passwordField as! UnderlineTextField
        emailField.setupEmailField()
        emailField.setup()
        confirmEmailField.setupEmailField()
        confirmEmailField.setup()
        passwordField.setupPasswordField()
        passwordField.setup()
        setup(navBar: navBar)
        setup(navigationButton: navigateBackButton)
        setup(emailField: self.emailField)
        passwordField.delegate = self
        passwordField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        setup(confirmEmailField: confirmEmailField)
        setup(passwordField: passwordField)
        setup(submitButton: submitButton)
        submitButton.layer.cornerRadius = 10
        navigateBackButton.addTarget(self, action: #selector(navigateBack), for: .touchUpInside)
        submitButton.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
    }
    
    func configure(model: LoginViewModel) {
        submitButton.isEnabled = true
    }
    
    private func sharedLayout(view: UIView) {
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        view.heightAnchor.constraint(equalTo: heightAnchor, multiplier: CreateAccountViewConstants.sharedHeightMultiplier).isActive = true
        view.widthAnchor.constraint(equalTo: widthAnchor, multiplier: CreateAccountViewConstants.sharedWidthMultiplier).isActive = true
    }
    
    private func setup(emailField: UITextField) {
        sharedLayout(view: emailField)
        emailField.topAnchor.constraint(equalTo: topAnchor, constant: UIScreen.main.bounds.height * 0.15).isActive = true
    }
    
    private func setup(confirmEmailField: UITextField) {
        sharedLayout(view: confirmEmailField)
        confirmEmailField.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: UIScreen.main.bounds.height * 0.045).isActive = true
    }
    
    private func setup(passwordField: UITextField) {
        sharedLayout(view: passwordField)
        passwordField.topAnchor.constraint(equalTo: confirmEmailField.bottomAnchor, constant: UIScreen.main.bounds.height * 0.045).isActive = true
    }
    
    private func setup(submitButton: UIButton) {
        addSubview(submitButton)
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        submitButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        submitButton.heightAnchor.constraint(equalTo: heightAnchor, multiplier: LoginViewConstants.sharedLayoutHeightMultiplier).isActive = true
        submitButton.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        submitButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: LoginViewConstants.submitButtonTopOffset).isActive = true
    }
    
    func submitButtonTapped() {
        guard let email = emailField.text, let password = passwordField.text else { return }
        delegate?.submitButton(tapped: true)
    }
    
    func setup(navBar: UIView) {
        addSubview(navBar)
        navBar.translatesAutoresizingMaskIntoConstraints = false
        navBar.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        navBar.heightAnchor.constraint(equalTo: heightAnchor, multiplier: PlayerViewConstants.trackTitleViewHeightMultiplier).isActive = true
        navBar.topAnchor.constraint(equalTo: topAnchor, constant: UIScreen.main.bounds.height * 0.03).isActive = true
        navBar.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
    
    func setup(navigationButton: UIButton) {
        navBar.addSubview(navigationButton)
        navigationButton.translatesAutoresizingMaskIntoConstraints = false
        navigationButton.leftAnchor.constraint(equalTo: navBar.leftAnchor, constant: UIScreen.main.bounds.width * 0.01).isActive = true
        navigationButton.centerYAnchor.constraint(equalTo: navBar.centerYAnchor).isActive = true
        navigationButton.heightAnchor.constraint(equalTo: navBar.heightAnchor, multiplier: 0.9).isActive = true
        navigationButton.widthAnchor.constraint(equalTo: navBar.widthAnchor, multiplier: 0.1).isActive = true
    }
    
    func navigateBack() {
        delegate?.navigateBack(tapped: true)
    }
}
