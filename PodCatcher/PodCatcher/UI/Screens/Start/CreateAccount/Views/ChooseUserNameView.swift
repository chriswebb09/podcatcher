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
    
    private func sharedLayout(view: UIView) {
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        view.heightAnchor.constraint(equalTo: heightAnchor, multiplier: CreateAccountViewConstants.sharedHeightMultiplier).isActive = true
        view.widthAnchor.constraint(equalTo: widthAnchor, multiplier: CreateAccountViewConstants.sharedWidthMultiplier).isActive = true
    }
}
