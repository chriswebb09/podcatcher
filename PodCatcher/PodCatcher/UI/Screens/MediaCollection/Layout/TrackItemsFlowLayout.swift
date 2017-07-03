import UIKit

// MARK: - UICollectionViewFlowLayout

class TrackItemsFlowLayout: UICollectionViewFlowLayout {
    
    func setup() {
        scrollDirection = .vertical
        itemSize = CGSize(width: UIScreen.main.bounds.width / 3.5, height: UIScreen.main.bounds.height / 5.3)
        sectionInset = UIEdgeInsets(top: 0, left: 15, bottom: 20, right: 15)
        minimumLineSpacing = 20
    }

}
    
    
//    func setup() {
//        scrollDirection = .vertical
//        itemSize = CGSize(width: UIScreen.main.bounds.width / 5, height: UIScreen.main.bounds.height / 9)
//        sectionInset = UIEdgeInsets(top: 2, left: 15, bottom: 20, right: 15)
//        minimumLineSpacing = 5
//    }
//}
