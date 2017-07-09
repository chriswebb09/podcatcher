import UIKit

extension HomeViewController: UICollectionViewDelegate {
    
    func setup(view: UIView, newLayout: HomeItemsFlowLayout) {
        newLayout.setup()
        setupHome(with: newLayout)
        collectionView.frame = CGRect(x: 0, y: view.bounds.midY, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 2)
        collectionView.backgroundColor = .white
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func setupHome(with newLayout: HomeItemsFlowLayout) {
        collectionView.collectionViewLayout = newLayout
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch dataSource.dataType {
        case .local:
            delegate?.didSelect(at: indexPath.row)
        case .network:
            delegate?.didSelect(at: indexPath.row, with: dataSource.items[indexPath.row])
        }
    }
    
    func logoutTapped() {
        delegate?.logout(tapped: true)
    }
}

extension HomeViewController: UIScrollViewDelegate {
    
    func collectionViewConfiguration() {
        setup(view: view, newLayout: HomeItemsFlowLayout())
        collectionView.delegate = self
        collectionView.dataSource = dataSource
        collectionView.isPagingEnabled = true
        collectionView.isScrollEnabled = true
        collectionView.decelerationRate = UIScrollViewDecelerationRateFast
        collectionView.backgroundColor = .clear
    }
}
