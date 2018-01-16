import UIKit

final class BrowseItemsFlowLayout: UICollectionViewFlowLayout {
    
    func setup() {
        if #available(iOS 11, *) {
            itemSize = CGSize(width: UIScreen.main.bounds.width / 1.6, height: UIScreen.main.bounds.height / 3)
        } else {
            itemSize = CGSize(width: UIScreen.main.bounds.width / 2, height: UIScreen.main.bounds.height / 3.2)
        }
        scrollDirection = .horizontal
        sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        minimumLineSpacing = 0
    }
    
    var appearingIndexPath: IndexPath?
    
    override func initialLayoutAttributesForAppearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        
        guard let attributes = super.initialLayoutAttributesForAppearingItem(at: itemIndexPath), let indexPath = appearingIndexPath , indexPath == itemIndexPath else { return nil }
        attributes.alpha = 1.0
        attributes.center = CGPoint(x: collectionView!.frame.width - 23.5, y: -24.5)
        attributes.transform = CGAffineTransform(scaleX: 0.15, y: 0.15)
        attributes.zIndex = 5
        return attributes
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        var cache = [UICollectionViewLayoutAttributes]()
        if let layoutAttributes = super.layoutAttributesForElements(in: rect) {
            for attributes in layoutAttributes {
                let cellAttributes = attributes.copy() as! UICollectionViewLayoutAttributes
                cache.append(cellAttributes)
            }
        }
        return cache
    }
}
