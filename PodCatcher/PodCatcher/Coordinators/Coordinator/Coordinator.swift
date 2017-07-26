import Foundation

enum CoordinatorType {
    case app, tabbar
}

protocol CoordinatorDelegate: class {
    func transitionCoordinator(type: CoordinatorType, dataSource: BaseMediaControllerDataSource?)
    func updatePodcast(with playlistId: String)
    func podcastItem(toAdd: CasterSearchResult, with index: Int)
}

protocol Coordinator: class {
    weak var delegate: CoordinatorDelegate? { get set }
    var type: CoordinatorType { get set } 
    func start()
}
