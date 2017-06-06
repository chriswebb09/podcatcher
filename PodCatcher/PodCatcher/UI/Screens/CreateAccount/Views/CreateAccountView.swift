import UIKit

final class CreateAccountView: UIView {
    
    weak var delegate: CreateAccountViewDelegate?
    
    // MARK: - UI Element Properties
    
    var usernameField: TextFieldExtension = {
        let usernameField = TextFieldExtension()
        usernameField.placeholder = "Username"
        usernameField.layer.borderColor = UIColor.lightGray.cgColor
        usernameField.layer.borderWidth = 1
        return usernameField
    }()
    
    var emailField: TextFieldExtension = {
        let emailField = TextFieldExtension()
        emailField.placeholder = "Email"
        emailField.layer.borderColor = UIColor.lightGray.cgColor
        emailField.layer.borderWidth = 1
        return emailField
    }()
    
    var passwordField: TextFieldExtension = {
        let passwordField = TextFieldExtension()
        passwordField.placeholder = "Password"
        passwordField.layer.borderColor = UIColor.lightGray.cgColor
        passwordField.layer.borderWidth = 1
        return passwordField
    }()
    
    var confirmPasswordField: TextFieldExtension = {
        let confirmPasswordField = TextFieldExtension()
        confirmPasswordField.layer.borderColor = UIColor.lightGray.cgColor
        return confirmPasswordField
    }()
    
    private var submitButton: UIButton = {
        let submitButton = BasicButtonFactory(text: "Create Account", textColor: .white, borderWidth: 2, borderColor: UIColor.blue.cgColor, backgroundColor: .lightGray)
        return submitButton.createButton()
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = .white
        
        setup(usernameField: usernameField)
        setup(emailField: emailField)
        setup(passwordField: passwordField)
        setup(submitButton: submitButton)
        usernameField.layer.cornerRadius = 20
        passwordField.layer.cornerRadius = 20
        emailField.layer.cornerRadius = 20
        submitButton.layer.cornerRadius = 20
        tag = 3
        submitButton.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
    }
    
    private func sharedLayout(view: UIView) {
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        view.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.09).isActive = true
        view.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.9).isActive = true
    }
    
    private func setup(usernameField: TextFieldExtension) {
        sharedLayout(view: usernameField)
        usernameField.topAnchor.constraint(equalTo: topAnchor, constant: UIScreen.main.bounds.height * 0.2).isActive = true
    }
    
    private func setup(emailField: TextFieldExtension) {
        sharedLayout(view: emailField)
        emailField.topAnchor.constraint(equalTo: usernameField.bottomAnchor, constant: UIScreen.main.bounds.height * 0.07).isActive = true
    }
    
    
    private func setup(passwordField: TextFieldExtension) {
        sharedLayout(view: passwordField)
        passwordField.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: UIScreen.main.bounds.height * 0.07).isActive = true
    }
    
    private func setup(submitButton: UIButton) {
        sharedLayout(view: submitButton)
        submitButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: UIScreen.main.bounds.height * 0.12).isActive = true
    }
    
    func submitButtonTapped() {
        delegate?.submitButtonTapped()
    }
}
