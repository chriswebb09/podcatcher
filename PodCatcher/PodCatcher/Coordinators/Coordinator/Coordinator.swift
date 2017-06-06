import Foundation

protocol Coordinator: class {
    weak var delegate: CoordinatorDelegate? { get set }
    func start()
}
