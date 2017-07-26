import Foundation

enum MenuActive {
    case none, active, hidden
}

protocol MenuDelegate: class {
    func optionOne(tapped: Bool)
    func optionTwo(tapped: Bool)
    func optionThree(tapped: Bool)
    func cancel(tapped: Bool)
}
