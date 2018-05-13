import UIKit

protocol BrowseViewControllerDelegate: class {
    func goToSearch()
    //func selectedItem(at: Int, podcast: PodcastItem, imageView: UIImageView)
    func selectedItem(at: Int, podcast: Podcast, imageView: UIImageView)
}
