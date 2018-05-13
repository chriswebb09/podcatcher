import UIKit

protocol PlayerViewControllerDelegate: class {
    func navigateBack(tapped: Bool)
    func addItemToPlaylist(item: PodcastItem, index: Int)
    func saveItemCoreData(item: PodcastItem, index: Int, image: UIImage) 
}
