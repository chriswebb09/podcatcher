import UIKit

// MARK: - CreateAccountViewDelegate

extension CreateAccountViewController: CreateAccountViewDelegate {
    
    func submitButton(tapped: Bool) {
        delegate?.submitButton(tapped: tapped)
    }
}
