import UIKit

extension StartViewController: StartViewDelegate {
    
    func continueAsGuestTapped() {
        showLoadingView(loadingPop: loadingPop)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
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
