import UIKit

protocol Reusable { }

extension Reusable where Self: UICollectionViewCell  {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
