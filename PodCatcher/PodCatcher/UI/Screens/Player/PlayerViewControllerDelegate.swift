import UIKit

protocol PlayerViewControllerDelegate: class {
    func navigateBack(tapped: Bool)
    func addItemToPlaylist(item: CasterSearchResult, index: Int)
    func saveItemCoreData(item: CasterSearchResult, index: Int, image: UIImage) 
}
