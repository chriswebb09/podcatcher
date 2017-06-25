import UIKit

class MediaCollectionDataSource: BaseMediaControllerDataSource {
    
    var viewShown: ShowView {
        if casters.count > 0 {
            return .collection
        } else {
            return .empty
        }
    }
}

extension MediaCollectionDataSource: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as MediaCell
        if let artWork = casters[indexPath.row].artwork, let name = casters[indexPath.row].name {
            let model = MediaCellViewModel(trackName: name, albumImageURL: artWork)
            DispatchQueue.main.async {
                cell.configureCell(with: model, withTime: (Double(indexPath.row) * 0.01))
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return count
    }
}
