import UIKit

class FavoritePodcastsViewController: MediaCollectionViewController {
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        collectionView.reloadData()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var count = 0
        if let user = dataSource.user {
            for (i, n) in user.favoriteCasts {
                count += 1
                print(count)
            }
        }
        return count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        viewShown = .collection
        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as MediaCell
        if let artWork = dataSource.casters[indexPath.row].artwork, let name = dataSource.casters[indexPath.row].name {
            let model = MediaCellViewModel(trackName: name, albumImageURL: artWork)
            cell.configureCell(with: model, withTime: (Double(indexPath.row) * 0.01))
        }
        return cell
    }
}
