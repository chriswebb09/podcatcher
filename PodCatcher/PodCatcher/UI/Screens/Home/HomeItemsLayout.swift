import UIKit

class HomeItemsFlowLayout: UICollectionViewFlowLayout {
    
    func setup() {
        scrollDirection = .horizontal
        itemSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 2)
        sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        minimumLineSpacing = 20
    }
    
}

    
