import UIKit

// MARK: - PreferencesViewDelegate

extension ListTopView: PreferencesViewDelegate {
    func addTagButton(tapped: Bool) {
        delegate?.entryPop(popped: tapped)
    }

    func moreButton(tapped: Bool) {
        delegate?.popBottomMenu(popped: tapped)
    }
}

protocol PreferencesViewDelegate: class {
    func moreButton(tapped: Bool)
    func addTagButton(tapped: Bool)
}
