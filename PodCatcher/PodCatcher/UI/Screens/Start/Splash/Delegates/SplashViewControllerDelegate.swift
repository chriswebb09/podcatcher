import Foundation

protocol SplashViewControllerDelegate: class {
    func splashAnimation(finished: Bool)
}

protocol SplashViewDelegate: class {
    func animation(_ isComplete: Bool)
}
