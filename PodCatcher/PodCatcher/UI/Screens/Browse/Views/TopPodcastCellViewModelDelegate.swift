import UIKit

protocol TopPodcastCellViewModelDelegate: class {
    func cellViewModel(_ cellViewModel: TopPodcastCellViewModel, canDisplay image: UIImage) -> Bool
}
