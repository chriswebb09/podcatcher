import UIKit

class CreateAccountViewController: UIViewController {
    
    weak var delegate: CreateAccountViewControllerDelegate?
    
    let createAccountView = CreateAccountView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createAccountView.frame = UIScreen.main.bounds
        createAccountView.tag = 3
        edgesForExtendedLayout = []
        createAccountView.delegate = self
        view = createAccountView
        view.layoutSubviews()
        title = "Create Account"
        hideKeyboardWhenTappedAround()
       // setupDefaultUI()
        navigationController?.navigationBar.isHidden = false
      //  navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.barTintColor = UIColor.white
      //  navigationController?.navigationBar.barTintColor = .lightGray
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = true
    }
}
