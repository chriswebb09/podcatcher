import UIKit

final class CreateAccountView: UIView {
    
    weak var delegate: CreateAccountViewDelegate?
    
    // MARK: - UI Element Properties
    
    var usernameField: TextFieldExtension = {
        let usernameField = TextFieldExtension()
        usernameField.placeholder = "Username"
        usernameField.layer.borderColor = UIColor.lightGray.cgColor
        usernameField.layer.borderWidth = CreateAccountViewConstants.borderWidth
        return usernameField
    }()
    
    var emailField: TextFieldExtension = {
        let emailField = TextFieldExtension()
        emailField.placeholder = "Email"
        emailField.layer.borderColor = UIColor.lightGray.cgColor
        emailField.layer.borderWidth = CreateAccountViewConstants.borderWidth
        return emailField
    }()
    
    var passwordField: TextFieldExtension = {
        let passwordField = TextFieldExtension()
        passwordField.placeholder = "Password"
        passwordField.layer.borderColor = UIColor.lightGray.cgColor
        passwordField.layer.borderWidth = CreateAccountViewConstants.borderWidth
        return passwordField
    }()
    
    var confirmPasswordField: TextFieldExtension = {
        let confirmPasswordField = TextFieldExtension()
        confirmPasswordField.layer.borderColor = UIColor.lightGray.cgColor
        return confirmPasswordField
    }()
    
    private var submitButton: UIButton = {
        let submitButton = BasicButtonFactory(text: "Create Account", textColor: .white, borderWidth: CreateAccountViewConstants.borderWidth, borderColor: UIColor.blue.cgColor, backgroundColor: .lightGray)
        return submitButton.createButton()
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = .white
        
        setup(usernameField: usernameField)
        setup(emailField: emailField)
        setup(passwordField: passwordField)
        setup(submitButton: submitButton)
        usernameField.layer.cornerRadius = CreateAccountViewConstants.cornerRadius
        passwordField.layer.cornerRadius = CreateAccountViewConstants.cornerRadius
        emailField.layer.cornerRadius = CreateAccountViewConstants.cornerRadius
        submitButton.layer.cornerRadius = CreateAccountViewConstants.cornerRadius
        tag = 3
        submitButton.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
    }
    
    private func sharedLayout(view: UIView) {
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        view.heightAnchor.constraint(equalTo: heightAnchor, multiplier: CreateAccountViewConstants.sharedHeightMultiplier).isActive = true
        view.widthAnchor.constraint(equalTo: widthAnchor, multiplier: CreateAccountViewConstants.sharedWidthMultiplier).isActive = true
    }
    
    private func setup(usernameField: TextFieldExtension) {
        sharedLayout(view: usernameField)
        usernameField.topAnchor.constraint(equalTo: topAnchor, constant: CreateAccountViewConstants.usernameFieldTopOffset).isActive = true
    }
    
    private func setup(emailField: TextFieldExtension) {
        sharedLayout(view: emailField)
        emailField.topAnchor.constraint(equalTo: usernameField.bottomAnchor, constant: CreateAccountViewConstants.passwordFieldTopOffset).isActive = true
    }
    
    
    private func setup(passwordField: TextFieldExtension) {
        sharedLayout(view: passwordField)
        passwordField.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: CreateAccountViewConstants.passwordFieldTopOffset).isActive = true
    }
    
    private func setup(submitButton: UIButton) {
        sharedLayout(view: submitButton)
        submitButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: CreateAccountViewConstants.submitButtonTopOffset).isActive = true
    }
    
    func submitButtonTapped() {
        delegate?.submitButtonTapped()
    }
}

struct CreateAccountViewConstants {
    static let borderWidth: CGFloat = 1
    static let sharedWidthMultiplier: CGFloat =  0.9
    static let sharedHeightMultiplier: CGFloat = 0.09
    static let submitButtonTopOffset: CGFloat = UIScreen.main.bounds.height * 0.12
    static let passwordFieldTopOffset: CGFloat = UIScreen.main.bounds.height * 0.07
    static let usernameFieldTopOffset: CGFloat = UIScreen.main.bounds.height * 0.2
    static let cornerRadius: CGFloat = 20
}
