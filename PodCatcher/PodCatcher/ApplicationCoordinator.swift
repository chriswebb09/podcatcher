import UIKit

protocol ApplicationCoordinator {
    var appCoordinator: Coordinator! { get set }
    var window: UIWindow { get set }
    func start()
}
