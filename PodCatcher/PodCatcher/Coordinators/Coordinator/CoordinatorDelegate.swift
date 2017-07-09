import Foundation
import UIKit

protocol CoordinatorDelegate: class {
    func transitionCoordinator(type: CoordinatorType, dataSource: BaseMediaControllerDataSource?)
    func updatePodcast(with playlistId: String)
    func podcastItem(toAdd: CasterSearchResult, with index: Int)
   // func getViewController(from type: TabType) -> UIViewController
}
