import UIKit

final class CreateAccountView: UIView {
    
    weak var delegate: CreateAccountViewDelegate?
    
    // MARK: - UI Elements
    
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
        var borderColor = UIColor.lightText.cgColor
        let submitButton = BasicButtonFactory(text: "Submit", textColor: .white, borderWidth: 2, borderColor: borderColor, backgroundColor: .mainColor)
        return submitButton.createButton()
    }()
    
    // MARK: - Configuration Methods
    
    override func layoutSubviews() {
        tag = 1
        super.layoutSubviews()
        backgroundColor = .white
        let emailField = self.emailField as! UnderlineTextField
        let confirmEmailField = self.confirmEmailField as! UnderlineTextField
        let passwordField = self.passwordField as! UnderlineTextField
        emailField.setupEmailField()
        emailField.setup()
        confirmEmailField.setupEmailField()
        confirmEmailField.setup()
        let attributedString = NSMutableAttributedString(string: "Confirm Email Address")
        attributedString.addAttribute(NSKernAttributeName, value: CGFloat(1.5), range: NSRange(location: 0, length: attributedString.length))
        let fontAttribute = [NSFontAttributeName: UIFont.systemFont(ofSize: 14.0)]
        attributedString.addAttributes(fontAttribute, range: NSRange(location: 0, length: attributedString.length))
        confirmEmailField.attributedPlaceholder = attributedString
        passwordField.setupPasswordField()
        passwordField.setup()
        setup(emailField: self.emailField)
        passwordField.delegate = self
        passwordField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        setup(confirmEmailField: confirmEmailField)
        setup(passwordField: passwordField)
        setup(submitButton: submitButton)
        submitButton.layer.cornerRadius = 10
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
        emailField.topAnchor.constraint(equalTo: topAnchor, constant: UIScreen.main.bounds.height * 0.045).isActive = true
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
        sharedLayout(view: submitButton)
        submitButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: LoginViewConstants.submitButtonTopOffset).isActive = true
    }
    
    func submitButtonTapped() {
        guard let email = emailField.text, let password = passwordField.text else { return }
        delegate?.submitButton(tapped: true)
    }
}
