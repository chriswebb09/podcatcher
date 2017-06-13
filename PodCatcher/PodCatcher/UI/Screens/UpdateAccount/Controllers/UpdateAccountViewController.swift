import UIKit

class UpdateAccountViewController: UIViewController {
    
    var updateAccountView = UpdateAccountView()
    var dataSource: BaseMediaControllerDataSource!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let user = dataSource.user else { return }
        var model = UpdateAccountViewModel(username: user.username, password: "1234fake", submitEnabled: false)
        updateAccountView.configure(model: model)
        view.addView(view: updateAccountView, type: .full)
    }
}
