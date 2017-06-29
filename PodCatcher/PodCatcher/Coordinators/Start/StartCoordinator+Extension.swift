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
        //  guard let casters = dataSource.casters else { return }
        //        if casters.count < 0 {
        //            let newDataSource = BaseMediaControllerDataSource()
        //            self.dataSource = newDataSource
        //        }
        //   user.casts = casters
        dataSource.user = user
        delegate?.transitionCoordinator(type: .tabbar, dataSource: self.dataSource)
    }
}

extension StartCoordinator: CreateAccountViewControllerDelegate {
    func submitButton(tapped: Bool) {
        delegate?.transitionCoordinator(type: .tabbar, dataSource: dataSource)
    }
}

