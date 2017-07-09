import UIKit

class UpdateAccountView: UIView {
    
    weak var delegate: UpdateAccountViewDelegate?
    
    var model: UpdateAccountViewModel! {
        didSet {
            usernameField.text = model.username
            emailField.text = model.email
            usernameLabel.text = model.username
        }
    }
    
    // MARK: - UI Elements
    
    private lazy var usernameLabel: UILabel = {
        var label = UILabel()
        return label
    }()
    
    lazy var editUserNameButton: UIButton = {
        var editButton = UIButton()
        editButton.setTitle("Edit", for: .normal)
        return editButton
    }()
    
    var usernameField: UnderlineTextField = {
        var usernameField = UnderlineTextField()
        usernameField.placeholder = "Username"
        return usernameField
    }()
    
    var emailField: UnderlineTextField = {
        var emailField = UnderlineTextField()
        emailField.placeholder = "Email"
        return emailField
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
        setup(usernameLabel: usernameLabel)
        setup(editLabelButton: editUserNameButton)
        editUserNameButton.setTitleColor(.blue, for: .normal)
        editUserNameButton.addTarget(self, action: #selector(editTapped), for: .touchUpInside)
    }
    
    func configure(model: UpdateAccountViewModel) {
        usernameField.alpha = 0
        self.model = model
    }
    
    func editTapped() {
        usernameField.alpha = 1
        sendSubview(toBack: usernameLabel)
        usernameLabel.alpha = 0
        bringSubview(toFront: usernameField)
        editUserNameButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
    }
    
    func saveTapped() {
        usernameField.alpha = 0
        sendSubview(toBack: usernameField)
        usernameLabel.alpha = 1
        bringSubview(toFront: usernameLabel)
    }
    
    private func sharedLayout(view: UIView) {
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.leftAnchor.constraint(equalTo: leftAnchor, constant: UIScreen.main.bounds.width * 0.05).isActive = true
        view.heightAnchor.constraint(equalTo: heightAnchor, multiplier: LoginViewConstants.sharedLayoutHeightMultiplier).isActive = true
        view.widthAnchor.constraint(equalTo: widthAnchor, multiplier: UpdateAccountViewConstants.sharedLayoutWidthMultiplier).isActive = true
    }
    
    private func setup(usernamefield: UITextField) {
        sharedLayout(view: usernameField)
        usernamefield.topAnchor.constraint(equalTo: topAnchor, constant: LoginViewConstants.usernameFieldTopOffset).isActive = true
    }
    
    func setup(usernameLabel: UILabel) {
        sharedLayout(view: usernameLabel)
        usernameLabel.topAnchor.constraint(equalTo: topAnchor, constant: LoginViewConstants.usernameFieldTopOffset).isActive = true
    }
    
    func setup(editLabelButton: UIButton) {
        addSubview(editLabelButton)
        editLabelButton.translatesAutoresizingMaskIntoConstraints = false
        editLabelButton.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.07).isActive = true
        editLabelButton.leftAnchor.constraint(equalTo: usernameLabel.rightAnchor).isActive = true
        editLabelButton.centerYAnchor.constraint(equalTo: usernameLabel.centerYAnchor).isActive = true
        editLabelButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.2).isActive = true
    }
    
    private func setup(emailField: UITextField) {
        sharedLayout(view: emailField)
        emailField.topAnchor.constraint(equalTo: usernameField.bottomAnchor, constant: LoginViewConstants.passwordFieldTopOffset).isActive = true
    }
}
