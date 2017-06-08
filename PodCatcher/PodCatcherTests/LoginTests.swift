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
        let expect = expectation(description: "API Client returns proper number of items from search")
        UserLoginAPIClient.login(with: "testuser", and: "123456") { data in
            guard let userData = data.1 else { return }
            guard let testUsename = userData["username"] as? String else { return }
            guard let testEmail = userData["email"] as? String else { return }
            guard let testCasts = userData["casters"] as? [Caster] else { return }
            guard let customGenre = userData["customGenre"] as? [String] else { return }
            let user = PodCatcherUser(username: testUsename, emailAddress: testEmail)
            user.customGenres = customGenre
            user.casts = testCasts
            self.loginViewController.delegate?.successfulLogin(for: user)
            expect.fulfill()
        }
        waitForExpectations(timeout: 6) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        }
    }
}

class LoginTestDelegate: LoginViewControllerDelegate {
    func successfulLogin(for user: PodCatcherUser) {
        XCTAssertNotNil(user)
    }
}
