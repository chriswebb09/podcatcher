import Foundation

protocol TopViewDelegate: class {
    func popBottomMenu(popped: Bool)
    func entryPop(popped: Bool)
    func infoButton(tapped: Bool)
}
