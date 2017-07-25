import Foundation

protocol StartViewControllerDelegate: class {
    func continueAsGuestSelected()
}

protocol StartViewDelegate: class {
    func continueAsGuestTapped()
}
