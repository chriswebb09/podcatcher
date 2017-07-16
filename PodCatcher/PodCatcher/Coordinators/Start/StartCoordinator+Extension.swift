import UIKit

extension StartCoordinator: SplashViewControllerDelegate {
    
    func splashAnimation(finished: Bool) {
        let startViewController = StartViewController()
        startViewController.delegate = self
        addChild(viewController: startViewController)
    }
}

extension StartCoordinator: StartViewControllerDelegate {
    
    func loginSelected() {
        let loginViewController = LoginBuilder.build(delegate: self)
        navigationController.pushViewController(loginViewController, animated: false)
    }
    
    func createAccountSelected() {
        let createAccountViewController = CreateAccountViewController()
        createAccountViewController.delegate = self
        navigationController.pushViewController(createAccountViewController, animated: false)
    }
    
    func continueAsGuestSelected() {
        delegate?.transitionCoordinator(type: .tabbar, dataSource: dataSource)
    }
}

extension StartCoordinator: LoginViewControllerDelegate {
    
    func successfulLogin(for user: PodCatcherUser) {
        self.dataSource = BaseMediaControllerDataSource()
        dataSource.user = user
        delegate?.transitionCoordinator(type: .tabbar, dataSource: self.dataSource)
    }
    
    func navigateBack(tapped: Bool) {
        print("back")
    }
}

extension StartCoordinator: CreateAccountViewControllerDelegate {
    func submitButton(tapped: Bool) {
        delegate?.transitionCoordinator(type: .tabbar, dataSource: dataSource)
    }
}
