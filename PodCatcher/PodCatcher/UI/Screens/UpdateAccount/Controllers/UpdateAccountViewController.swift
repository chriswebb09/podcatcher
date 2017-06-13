import UIKit

class UpdateAccountViewController: UIViewController {
    
    weak var delegate: UpdateAccountViewControllerDelegate?
    var updateAccountView = UpdateAccountView()
    var dataSource: BaseMediaControllerDataSource!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let user = dataSource.user else { return }
        let model = UpdateAccountViewModel(username: user.username, email: user.emailAddress, submitEnabled: false)
        updateAccountView.configure(model: model)
        updateAccountView.delegate = self
        view.addView(view: updateAccountView, type: .full)
    }
}

extension UpdateAccountViewController: UpdateAccountViewDelegate {
    func emailUpdated(email: String) {
        delegate?.updated(email: email)
    }
    
    func usernameUpdated(username: String) {
        delegate?.updated(username: username)
    }
}
