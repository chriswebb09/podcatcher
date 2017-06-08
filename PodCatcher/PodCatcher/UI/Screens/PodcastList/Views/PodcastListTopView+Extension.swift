import UIKit

// MARK: - PreferencesViewDelegate

extension PodcastListTopView: PreferencesViewDelegate {
    
    func addTagButtonTapped(tapped: Bool) {
        delegate?.entryPop(pop: tapped)
    }
    
    func moreButtonTapped(tapped: Bool) {
        delegate?.popBottomMenu(pop: true)
    }
}
