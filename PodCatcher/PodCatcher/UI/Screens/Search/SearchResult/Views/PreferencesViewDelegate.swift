import Foundation

protocol PreferencesViewDelegate: class {
    func moreButton(tapped: Bool)
    func infoButton(tapped: Bool)
    func addTagButton(tapped: Bool)
}
