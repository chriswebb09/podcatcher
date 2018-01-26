import UIKit

final class BrowseItemsFlowLayout: UICollectionViewFlowLayout {

    func setup() {
        if #available(iOS 11, *) {
            itemSize = CGSize(width: UIScreen.main.bounds.width / 2.2, height: UIScreen.main.bounds.height / 3.99)
        } else {
            itemSize = CGSize(width: UIScreen.main.bounds.width / 2, height: UIScreen.main.bounds.height / 3.2)
        }
        scrollDirection = .vertical
        sectionInset = UIEdgeInsets(top: 5 , left: 10, bottom: 40, right: 10)
    }
}
