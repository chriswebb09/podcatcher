import UIKit

extension StartCoordinator: SplashViewControllerDelegate {
    
    func splashViewFinishedAnimation(finished: Bool) {
        let startViewController = StartViewController()
        startViewController.delegate = self
        addChild(viewController: startViewController)
    }
}

extension StartCoordinator: StartViewControllerDelegate {
    
    func loginSelected() {
        let loginView = LoginView()
        let loginModel = LoginViewModel()
        loginView.configure(model: loginModel)
        let loginViewController = LoginViewController(loginView: loginView)
        loginViewController.delegate = self
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
        if let dataSource = dataSource, dataSource.casters.count < 0 {
            let newDataSource = BaseMediaControllerDataSource(casters: user.casts)
            self.dataSource = newDataSource
        }
        user.casts = dataSource.casters
        dataSource.user = user
        delegate?.transitionCoordinator(type: .tabbar, dataSource: self.dataSource)
    }
}

extension StartCoordinator: CreateAccountViewControllerDelegate {
    
    func submitButtonTapped() {
        delegate?.transitionCoordinator(type: .tabbar, dataSource: dataSource)
    }
}
