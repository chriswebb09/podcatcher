import UIKit

class HomeItemsFlowLayout: UICollectionViewFlowLayout {
    func setup() {
        scrollDirection = .vertical
        itemSize = CGSize(width: UIScreen.main.bounds.width / 3.4, height: UIScreen.main.bounds.height / 6)
        sectionInset = UIEdgeInsets(top: 5, left: 10, bottom: 0, right: 10)
        minimumLineSpacing = 15
    }
}
