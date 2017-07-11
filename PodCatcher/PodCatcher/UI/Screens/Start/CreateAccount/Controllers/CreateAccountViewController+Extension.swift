import UIKit

// MARK: - CreateAccountViewDelegate

extension CreateAccountViewController: CreateAccountViewDelegate {
    
    func submitButton(tapped: Bool) {
        delegate?.submitButton(tapped: tapped)
    }
    
    func navigateBack(tapped: Bool) {
        delegate?.navigateBack(tapped: tapped)
        navigationController?.popViewController(animated: false)
    }
}
