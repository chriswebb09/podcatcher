import UIKit

final class LoginView: UIView {
    
    weak var delegate: LoginViewDelegate?
    
    var model: LoginViewModel! {
        didSet {
            model.submitEnabled = model.username.isValidEmail()
            submitButton.isEnabled = model.submitEnabled
        }
    }
    
    // MARK: - UI Elements
    
    fileprivate var usernameField: TextFieldExtension = {
        return TextFieldExtension.emailField("Email")
    }()
    
    private var passwordField: TextFieldExtension = {
        return TextFieldExtension.passwordField()
    }()
    
    fileprivate var submitButton: UIButton = {
        var borderColor = UIColor.lightText.cgColor
        let submitButton = BasicButtonFactory(text: "Login", textColor: .white, borderWidth: 2, borderColor: borderColor, backgroundColor: .mainColor)
        return submitButton.createButton()
    }()
    
    // MARK: - Configuration Methods
    
    override func layoutSubviews() {
        tag = 1
        super.layoutSubviews()
        backgroundColor = .white
        usernameField.delegate = self
        passwordField.delegate = self
        usernameField.layer.cornerRadius = 20
        passwordField.layer.cornerRadius = 20
        setup(usernamefield: usernameField)
        setup(passwordField: passwordField)
        setup(submitButton: submitButton)
        submitButton.layer.cornerRadius = 20
        submitButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
    }
    
    func configure(model: LoginViewModel) {
        self.model = model
        self.usernameField.text = "test@gmail.com"
        self.passwordField.text = "123456"
        self.submitButton.isEnabled = true
    }
    
    private func sharedLayout(view: UIView) {
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        view.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.09).isActive = true
        view.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.9).isActive = true
    }
    
    private func setup(usernamefield: TextFieldExtension) {
        sharedLayout(view: usernameField)
        usernamefield.topAnchor.constraint(equalTo: topAnchor, constant: UIScreen.main.bounds.height * 0.25).isActive = true
    }
    
    private func setup(passwordField: TextFieldExtension) {
        sharedLayout(view: passwordField)
        passwordField.topAnchor.constraint(equalTo: usernameField.bottomAnchor, constant: UIScreen.main.bounds.height * 0.1).isActive = true
    }
    
    private func setup(submitButton: UIButton) {
        sharedLayout(view: submitButton)
        submitButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: UIScreen.main.bounds.height * 0.17).isActive = true
    }
    
    func loginButtonTapped() {
        guard let username = usernameField.text, let password = passwordField.text else { return }
        delegate?.userEntryDataSubmitted(with: username, and: password)
    }
}
