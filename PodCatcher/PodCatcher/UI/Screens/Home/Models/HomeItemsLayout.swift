import UIKit


class HomeItemsFlowLayout: UICollectionViewFlowLayout {
    func setup() {
        scrollDirection = .vertical
        itemSize = CGSize(width: UIScreen.main.bounds.width / 5, height: UIScreen.main.bounds.height / 9)
        sectionInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        minimumLineSpacing = 0
    }
}

//class HomeItemsFlowLayout: UICollectionViewFlowLayout {
//    
//    func setup() {
//        scrollDirection = .horizontal
//        itemSize = CGSize(width: UIScreen.main.bounds.width / 2.5, height: UIScreen.main.bounds.height / 3.5)
//        sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
//        minimumLineSpacing = 40
//    }
//}
