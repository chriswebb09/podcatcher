import UIKit

// MARK: - CreateAccountViewDelegate

extension CreateAccountViewController: CreateAccountViewDelegate {
    
    func submitButtonTapped() {
        delegate?.submitButtonTapped()
    }
}
