import UIKit

protocol PlayerViewControllerDelegate: class {
    func navigateBack(tapped: Bool)
    func addItemToPlaylist(item: CasterSearchResult, index: Int)
}
