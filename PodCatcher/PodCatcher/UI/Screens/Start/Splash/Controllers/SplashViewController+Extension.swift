import UIKit

// MARK: - SplashViewDelegate

extension SplashViewController: SplashViewDelegate {
    
    func animation(_ isComplete: Bool) {
        print(isComplete)
        animate()
    }
    
    func animate() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            if let strongSelf = self {
                strongSelf.delegate?.splashAnimation(finished: true)
            }
        }
    }
}
