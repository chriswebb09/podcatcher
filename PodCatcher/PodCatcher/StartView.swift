import UIKit

final class StartView: UIView {
    
    weak var delegate: StartViewDelegate?
    
    // MARK: - UI Element Properties
    
    private var titleLabel: UILabel = {
        let title = UILabel()
        title.textAlignment = .center
        title.font = UIFont(name: "AvenirNext-Medium", size: 20)!
        return title
    }()
    
    private var guestUserButton: UIButton = {
        let guestUser = BasicButtonFactory(text: "Continue As Guest", textColor: .white, borderWidth: 2, borderColor: UIColor.blue.cgColor, backgroundColor: .mainColor)
        return guestUser.createButton()
    }()
    
    private var userLoginButton: UIButton = {
        let userLogin = LoginButtonFactory(text: "Log in to Account", textColor: .white, buttonBorderWidth: 2, buttonBorderColor: UIColor.blue.cgColor, buttonBackgroundColor: .mainColor)
        return userLogin.createButton()
    }()
    
    private var createAccountButton: UIButton = {
        let createAccount = LoginButtonFactory(text: "Create Account", textColor: .white, buttonBorderWidth: 2, buttonBorderColor: UIColor.blue.cgColor, buttonBackgroundColor: .mainColor)
        return createAccount.createButton()
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupElements()
        titleLabel.text = "Get started!"
        backgroundColor = .lightGray
        setupSelectors()
    }
    
    private func setupElements() {
        setup(titleLabel: titleLabel)
        setup(guestUserButton: guestUserButton)
        guestUserButton.layer.cornerRadius = 4
        setup(loginButton: userLoginButton)
        userLoginButton.layer.cornerRadius = 4
        setup(createAccountButton: createAccountButton)
        createAccountButton.layer.cornerRadius = 4
    }
    
    private func setupSelectors() {
        createAccountButton.addTarget(self, action: #selector(createAccountButtonTapped), for: .touchUpInside)
        guestUserButton.addTarget(self, action: #selector(guestUserButtonTapped), for: .touchUpInside)
        userLoginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
    }
    
    func guestUserButtonTapped() {
        delegate?.continueAsGuestTapped()
    }
    
    func createAccountButtonTapped() {
        delegate?.createAccountTapped()
    }
    
    func loginButtonTapped() {
        delegate?.loginTapped()
    }
    
    private func setup(titleLabel: UILabel) {
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: UIScreen.main.bounds.height * -0.25).isActive = true
        titleLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8).isActive = true
        titleLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.1).isActive = true
    }
    
    private func setup(guestUserButton: UIButton) {
        addSubview(guestUserButton)
        guestUserButton.translatesAutoresizingMaskIntoConstraints = false
        guestUserButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        guestUserButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: UIScreen.main.bounds.height * 0.07).isActive = true
        guestUserButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8).isActive = true
        guestUserButton.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.1).isActive = true
    }
    
    private func setup(loginButton: UIButton) {
        addSubview(loginButton)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        loginButton.topAnchor.constraint(equalTo: guestUserButton.bottomAnchor, constant: UIScreen.main.bounds.height * 0.07).isActive = true
        loginButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8).isActive = true
        loginButton.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.1).isActive = true
    }
    
    private func setup(createAccountButton: UIButton) {
        addSubview(createAccountButton)
        createAccountButton.translatesAutoresizingMaskIntoConstraints = false
        createAccountButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        createAccountButton.centerYAnchor.constraint(equalTo: centerYAnchor, constant: UIScreen.main.bounds.height * 0.25).isActive = true
        createAccountButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8).isActive = true
        createAccountButton.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.1).isActive = true
    }
}
