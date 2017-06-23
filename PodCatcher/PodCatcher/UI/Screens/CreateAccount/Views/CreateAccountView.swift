import UIKit

final class CreateAccountView: UIView {
    
    weak var delegate: CreateAccountViewDelegate?
    
//    var model: LoginViewModel! {
//        didSet {
//            submitButton.isEnabled = model.validContent
//            submitButton.backgroundColor = model.buttonColor
//            dump(model.buttonColor)
//        }
//    }
    
    // MARK: - UI Elements
    
//    var usernameField: UITextField = {
//        var usernameField = UnderlineTextField()
//        usernameField.placeholder = "Username"
//        return usernameField
//    }()
    
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
        
   //     let usernameField = self.usernameField as! UnderlineTextField
        let emailField = self.emailField as! UnderlineTextField
        let confirmEmailField = self.confirmEmailField as! UnderlineTextField
        let passwordField = self.passwordField as! UnderlineTextField
        emailField.setupEmailField()
        emailField.setup()
       // usernameField.setupUserField()
       // usernameField.setup()
        confirmEmailField.setupEmailField()
        confirmEmailField.setup()
        let attributedString = NSMutableAttributedString(string: "Confirm Email Address")
        attributedString.addAttribute(NSKernAttributeName, value: CGFloat(1.5), range: NSRange(location: 0, length: attributedString.length))
        let fontAttribute = [NSFontAttributeName: UIFont.systemFont(ofSize: 14.0)]
        attributedString.addAttributes(fontAttribute, range: NSRange(location: 0, length: attributedString.length))
        confirmEmailField.attributedPlaceholder = attributedString
        passwordField.setupPasswordField()
        passwordField.setup()
       // setup(usernamefield: usernameField)
        setup(emailField: self.emailField)
      //  usernameField.delegate = self
        passwordField.delegate = self
      //  usernameField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
       // passwordField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        setup(confirmEmailField: confirmEmailField)
        setup(passwordField: passwordField)
        setup(submitButton: submitButton)
        submitButton.layer.cornerRadius = 10
        submitButton.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
    }
    
    func configure(model: LoginViewModel) {
       // self.model = model
   //     usernameField.text = "Link@link.com"
   //     passwordField.text = "123456"
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
       // guard let username = usernameField.text, let password = passwordField.text else { return }
        delegate?.submitButtonTapped()
    }
}


extension CreateAccountView: UITextFieldDelegate {
//    
//    func textFieldDidChange(_ textField: UITextField) {
//        textField.textColor = .black
//        
//        guard let text = textField.text else { return }
//        if textField == emailField {
//            model.username = text
//        } else {
//            model.password = text
//        }
//    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.placeholder = "" 
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        endEditing(true)
        return true
    }
}
