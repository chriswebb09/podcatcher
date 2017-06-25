import UIKit

// MARK: - PreferencesViewDelegate

extension PodcastListTopView: PreferencesViewDelegate {
    func addTagButton(tapped: Bool) {
        delegate?.entryPop(popped: tapped)
    }

    func moreButton(tapped: Bool) {
        delegate?.popBottomMenu(popped: tapped)
    }
}
