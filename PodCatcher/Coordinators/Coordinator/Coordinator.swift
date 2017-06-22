import Foundation

protocol Coordinator: class {
    weak var delegate: CoordinatorDelegate? { get set }
    var type: CoordinatorType { get set } 
    func start()
}
