import UIKit

class BrowseItemsFlowLayout: UICollectionViewFlowLayout {
    
    func setup() {
        scrollDirection = .horizontal
        itemSize = CGSize(width: UIScreen.main.bounds.width / 2, height: UIScreen.main.bounds.height / 2.8)
        sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 15)
        minimumLineSpacing = 30
    }
}
