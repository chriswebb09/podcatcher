import UIKit

final class ChooseUsernameView: UIView {
    var usernameField: UITextField = {
        var usernameField = UnderlineTextField()
        usernameField.placeholder = "Username"
        return usernameField
    }()
    
    private func setup(usernamefield: UITextField) {
        sharedLayout(view: usernameField)
        usernamefield.topAnchor.constraint(equalTo: topAnchor, constant: UIScreen.main.bounds.height * 0.08).isActive = true
    }
}
