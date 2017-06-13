import UIKit

class UpdateAccountView: UIView {
    
    var model: UpdateAccountViewModel! {
        didSet {
            usernameField.text = model.username
            //model.submitEnabled = model.username.isValidEmail()
        }
    }
    
    // MARK: - UI Elements
    
    fileprivate var usernameField: UITextField = {
        var field = TextFieldExtension.emailField("Email")
        return UnderlineTextField(frame: field.frame)
    }()
    
    // MARK: - Configuration Methods
    
    override func layoutSubviews() {
        tag = 1
        super.layoutSubviews()
        backgroundColor = .white
        var field = usernameField as! UnderlineTextField
        field.setup()
        field.placeholder = "Username"
        setup(usernamefield: usernameField)
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
    
    private func setup(passwordField: TextFieldExtension) {
        sharedLayout(view: passwordField)
        passwordField.topAnchor.constraint(equalTo: usernameField.bottomAnchor, constant: LoginViewConstants.passwordFieldTopOffset).isActive = true
    }
}
