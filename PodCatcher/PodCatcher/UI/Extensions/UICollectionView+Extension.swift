import UIKit
import Foundation

class TrackItemsFlowLayout: UICollectionViewFlowLayout {
    
    func setup() {
        scrollDirection = .vertical
        itemSize = CGSize(width: UIScreen.main.bounds.width / 3.4, height: UIScreen.main.bounds.height / 5.4)
        sectionInset = UIEdgeInsets(top: 0, left: 12, bottom: 30, right: 12)
        minimumLineSpacing = 20
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
    
    func tetherToController(controller: UIViewController) {
        self.dataSource = controller as? UICollectionViewDataSource
        self.delegate = controller as? UICollectionViewDelegate
    }
    
    func setup(with newLayout: TrackItemsFlowLayout) {
        newLayout.setup()
        collectionViewLayout = newLayout
        frame = UIScreen.main.bounds
    }
    
    func collectionViewRegister(viewController: UIViewController) {
        tetherToController(controller: viewController)
    }
    
    func setupCollectionView(view: UIView, newLayout: TrackItemsFlowLayout) {
        
        setup(with: newLayout)
        frame = UIScreen.main.bounds
        backgroundColor = .white
        // guard let tabbarHeight = self.tabBarController?.tabBar.frame.height else { return }
        contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func setupBackground(frame: CGRect) {
        let collectionBackgroundView = UIView(frame: frame)
        backgroundView = collectionBackgroundView
    }
}
