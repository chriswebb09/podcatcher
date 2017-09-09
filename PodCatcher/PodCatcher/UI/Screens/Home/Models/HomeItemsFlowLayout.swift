import UIKit

class HomeItemsFlowLayout: UICollectionViewFlowLayout {
    
    func setup() {
        scrollDirection = .vertical
        itemSize = CGSize(width: UIScreen.main.bounds.width / 3.2, height: UIScreen.main.bounds.height / 6.6)
        sectionInset = UIEdgeInsets(top: 5, left: 6, bottom: 0, right: 6)
        minimumInteritemSpacing = 0.46
        minimumLineSpacing = 6
    }
    
    var appearingIndexPath: IndexPath?
    
    override func initialLayoutAttributesForAppearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        
        guard let attributes = super.initialLayoutAttributesForAppearingItem(at: itemIndexPath), let indexPath = appearingIndexPath , indexPath == itemIndexPath else {
            return nil
        }
        
        attributes.alpha = 1.0
        attributes.center = CGPoint(x: collectionView!.frame.width - 23.5, y: -24.5)
        attributes.transform = CGAffineTransform(scaleX: 0.15, y: 0.15)
        attributes.zIndex = 5
        
        return attributes
    }
    
    override func prepare() {
        scrollDirection = .vertical
        itemSize = CGSize(width: UIScreen.main.bounds.width / 3.2, height: UIScreen.main.bounds.height / 6.4)
        sectionInset = UIEdgeInsets(top: 5, left: 6, bottom: 0, right: 6)
        minimumInteritemSpacing = 0.46
        minimumLineSpacing = 6
        super.prepare()
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
