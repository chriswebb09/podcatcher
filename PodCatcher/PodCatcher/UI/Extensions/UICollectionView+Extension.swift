import UIKit
import Foundation

class TrackItemsFlowLayout: UICollectionViewFlowLayout {
    
    func setup() {
        scrollDirection = .vertical
        itemSize = CGSize(width: UIScreen.main.bounds.width / 3.4, height: UIScreen.main.bounds.height / 5.4)
        sectionInset = UIEdgeInsets(top: 0, left: 12, bottom: 30, right: 12)
        minimumLineSpacing = 5
      //  minimumLineSpacing = 20
    }
}

extension UICollectionView {
    
    func register<T: UICollectionViewCell>(_ :T.Type) {
        register(T.self, forCellWithReuseIdentifier: T.reuseIdentifier)
    }
    
    func dequeueReusableCell<T: UICollectionViewCell>(forIndexPath indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not deque cell")
        }
        return cell
    }
    
    func setupBackground(frame: CGRect) {
        let collectionBackgroundView = UIView(frame: frame)
        backgroundView = collectionBackgroundView
    }
    
    func updateCollectionViewLayout() {
        DispatchQueue.main.async {
         //   self.reloadSections(IndexSet(integersIn: 0...0))
           // self.reloadItems(at: self.indexPathsForVisibleItems)
            self.layoutIfNeeded()
        }
    }
}

extension UICollectionViewFlowLayout {
    
    var collectionViewWidthWithoutInsets: CGFloat {
        get {
            guard let collectionView = self.collectionView else { return 0 }
            let collectionViewSize = collectionView.bounds.size
            let widthWithoutInsets = collectionViewSize.width
                - self.sectionInset.left - self.sectionInset.right
                - collectionView.contentInset.left - collectionView.contentInset.right
            return widthWithoutInsets
        }
    }
}

final class SearchItemsFlowLayout: UICollectionViewFlowLayout {
    
    func setup() {
        scrollDirection = .vertical
        itemSize = CGSize(width: UIScreen.main.bounds.width / 1.01, height: UIScreen.main.bounds.height / 10)
        sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 30, right: 0)
        minimumLineSpacing = 1
    }
}
