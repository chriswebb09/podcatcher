import UIKit

// MARK: - StartViewDelegate

extension StartViewController: StartViewDelegate {
    
    func continueAsGuestTapped() {
        showLoadingView(loadingPop: loadingPop)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.delegate?.continueAsGuestSelected()
        }
    }
    
    func createAccountTapped() {
        delegate?.createAccountSelected()
    }
    
    func loginTapped() {
        delegate?.loginSelected()
    }
}
