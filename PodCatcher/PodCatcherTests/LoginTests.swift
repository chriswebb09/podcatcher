import XCTest
@testable import PodCatcher

class LoginTests: XCTestCase {
    
    var loginView: LoginView!
    var loginViewController: LoginViewController!
    
    override func setUp() {
        super.setUp()
        loginView = LoginView()
        loginViewController = LoginViewController()
    }
    
    override func tearDown() {
        loginView = nil
        loginViewController = nil
        super.tearDown()
    }
    
    func testSubmitButtonEnabled() {
        var loginViewModel = LoginViewModel()
        loginViewModel.password = "1234567"
        loginViewModel.username = "hello@gmail.com"
        loginView.configure(model: loginViewModel)
        XCTAssertTrue(loginView.model.submitEnabled)
    }
}

class LoginTestDelegate: LoginViewControllerDelegate {
    func successfulLogin(for user: PodCatcherUser) {
        XCTAssertNotNil(user)
    }
}
