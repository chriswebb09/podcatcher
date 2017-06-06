import UIKit

final class CreateAccountView: UIView {
    
    weak var delegate: CreateAccountViewDelegate?
    
    // MARK: - UI Element Properties
    
    var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "Create Your Account"
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center
        return titleLabel
    }()
    
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
        passwordField.layer.borderColor = UIColor.lightGray.cgColor
        return passwordField
    }()
    
    var confirmPasswordField: TextFieldExtension = {
        let confirmPasswordField = TextFieldExtension()
        return confirmPasswordField
    }()
    
    private var submitButton: UIButton = {
        let submitButton = BasicButtonFactory(text: "Create Account", textColor: .white, borderWidth: 2, borderColor: UIColor.blue.cgColor, backgroundColor: .lightGray)
        return submitButton.createButton()
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = .white
        setup(titleLabel: titleLabel)
        setup(usernameField: usernameField)
        setup(emailField: emailField)
        setup(submitButton: submitButton)
        tag = 3
        submitButton.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
    }
    
    func setup(titleLabel: UILabel) {
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: UIScreen.main.bounds.height * -0.25).isActive = true
        titleLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.4).isActive = true
        titleLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.1).isActive = true
    }
    
    private func setup(usernameField: TextFieldExtension) {
        addSubview(usernameField)
        usernameField.translatesAutoresizingMaskIntoConstraints = false
        usernameField.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        usernameField.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.09).isActive = true
        usernameField.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.9).isActive = true
        usernameField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: UIScreen.main.bounds.height * 0.07).isActive = true
    }
    
    private func setup(emailField: TextFieldExtension) {
        addSubview(emailField)
        emailField.translatesAutoresizingMaskIntoConstraints = false
        emailField.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        emailField.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.09).isActive = true
        emailField.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.9).isActive = true
        emailField.topAnchor.constraint(equalTo: usernameField.bottomAnchor, constant: UIScreen.main.bounds.height * 0.07).isActive = true
    }
    
    private func setup(submitButton: UIButton) {
        addSubview(submitButton)
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        submitButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        submitButton.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.09).isActive = true
        submitButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.9).isActive = true
        submitButton.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: UIScreen.main.bounds.height * 0.09).isActive = true
    }
    
    func submitButtonTapped() {
        delegate?.submitButtonTapped()
    }
}
