import UIKit

protocol Coordinator: class {
    var delegate: CoordinatorDelegate? { get set }
    var type: CoordinatorType { get set }
    func start()
}


