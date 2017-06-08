import UIKit

 // MARK: - SplashViewDelegate

extension SplashViewController: SplashViewDelegate {
    
    func animationIsComplete() {
        animate()
    }
    
    func animate() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.delegate?.splashViewFinishedAnimation(finished: true)
        }
    }
}
