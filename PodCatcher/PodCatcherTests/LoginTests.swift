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
    
    func testGoToLogin() {
        let appCoordinator = StartCoordinator(navigationController: UINavigationController(rootViewController: loginViewController))
        appCoordinator.window = UIWindow(frame: UIScreen.main.bounds)
        let dataSource = BaseMediaControllerDataSource(casters: [Caster]())
        appCoordinator.dataSource = dataSource
        appCoordinator.addChild(viewController: loginViewController)
        XCTAssert(appCoordinator.childViewControllers[0] == loginViewController)
    }
    
    func testSubmitButtonEnabled() {
        let textField = UITextField()
        let loginViewModel = LoginViewModel()
        textField.text = "hello@gmail.com"
        loginView.model = loginViewModel
        loginView.textFieldDidEndEditing(textField)
        XCTAssertTrue(loginView.model.submitEnabled)
    }
    
    func testSubmitButtonTapped() {
        let loginTest = LoginTestDelegate()
        loginViewController.delegate = loginTest
        loginViewController.userEntryDataSubmitted(with: "Link@link.com", and: "123456")
        let expect = expectation(description: "User exists")
        UserDataAPIClient.loginToAccount(email: "Link@link.com", password: "123456") { user in
            XCTAssertNotNil(user)
            expect.fulfill()
        }
        waitForExpectations(timeout: 4) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout error: \(error)")
            }
        }
    }
}

class LoginTestDelegate: LoginViewControllerDelegate {
    func successfulLogin(for user: PodCatcherUser) {
        XCTAssertNotNil(user)
    }
}
