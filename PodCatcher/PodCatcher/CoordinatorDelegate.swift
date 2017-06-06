import Foundation

protocol CoordinatorDelegate: class {
    func transitionCoordinator(type: CoordinatorType, dataSource: BaseMediaControllerDataSource?)
}
