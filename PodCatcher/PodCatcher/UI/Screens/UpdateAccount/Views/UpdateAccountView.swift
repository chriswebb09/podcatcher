import UIKit

class UpdateAccountView: UIView {
    
    weak var delegate: UpdateAccountViewDelegate?
    
    var model: UpdateAccountViewModel! {
        didSet {
            usernameField.text = model.username
            emailField.text = model.email
        }
    }
    
    // MARK: - UI Elements
    
    fileprivate var usernameField: UnderlineTextField = {
        var test = UnderlineTextField()
        return UnderlineTextField()
    }()
    
    fileprivate var emailField: UnderlineTextField = {
        return UnderlineTextField()
    }()
    
    // MARK: - Configuration Methods
    
    override func layoutSubviews() {
        tag = 1
        super.layoutSubviews()
        backgroundColor = .white
        usernameField.setup()
        usernameField.placeholder = "Username"
        usernameField.delegate = self
        emailField.setup()
        emailField.placeholder = "Email"
        emailField.delegate = self
        setup(usernamefield: usernameField)
        setup(emailField: emailField)
    }
    
    func configure(model: UpdateAccountViewModel) {
        self.model = model
    }
    
    private func sharedLayout(view: UIView) {
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        view.heightAnchor.constraint(equalTo: heightAnchor, multiplier: LoginViewConstants.sharedLayoutHeightMultiplier).isActive = true
        view.widthAnchor.constraint(equalTo: widthAnchor, multiplier: LoginViewConstants.sharedLayoutWidthMultiplier).isActive = true
    }
    
    private func setup(usernamefield: UITextField) {
        sharedLayout(view: usernameField)
        usernamefield.topAnchor.constraint(equalTo: topAnchor, constant: LoginViewConstants.usernameFieldTopOffset).isActive = true
    }
    
    private func setup(emailField: UITextField) {
        sharedLayout(view: emailField)
        emailField.topAnchor.constraint(equalTo: usernameField.bottomAnchor, constant: LoginViewConstants.passwordFieldTopOffset).isActive = true
    }
}

extension UpdateAccountView: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == usernameField {
            guard let text = textField.text else { return }
            delegate?.usernameUpdated(username: text)
        } else if textField == emailField {
            guard let text = textField.text, text.isValidEmail() else { return }
            delegate?.emailUpdated(email: text)
        }
    }
}
