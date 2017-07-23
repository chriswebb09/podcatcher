import UIKit

extension StartCoordinator: SplashViewControllerDelegate {
    
    func splashAnimation(finished: Bool) {
        let startViewController = StartViewController()
        startViewController.delegate = self
        addChild(viewController: startViewController)
    }
}

extension StartCoordinator: StartViewControllerDelegate {
    
    func continueAsGuestSelected() {
        delegate?.transitionCoordinator(type: .tabbar, dataSource: dataSource)
    }
}
