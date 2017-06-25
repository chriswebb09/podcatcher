import UIKit

// MARK: - PreferencesViewDelegate

extension PodcastListTopView: PreferencesViewDelegate {
    func addTagButton(tapped: Bool) {
        print("tag")
        delegate?.entryPop(popped: tapped)
    }

    func moreButton(tapped: Bool) {
        print("more")
        delegate?.popBottomMenu(popped: tapped)
    }
}
