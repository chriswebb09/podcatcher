import UIKit

final class BrowseItemsFlowLayout: UICollectionViewFlowLayout {

    func setup() {
        if #available(iOS 11, *) {
            itemSize = CGSize(width: UIScreen.main.bounds.width / 2.2, height: UIScreen.main.bounds.width / 2.2)
        } else {
            itemSize = CGSize(width: UIScreen.main.bounds.width / 2, height: UIScreen.main.bounds.height / 3.2)
        }
        minimumLineSpacing = 2
        scrollDirection = .vertical
        sectionInset = UIEdgeInsets(top: 6 , left: 6, bottom: 0, right: 6)
        
    }
}
