import UIKit

class HomeItemsFlowLayout: UICollectionViewFlowLayout {
    
    func setup() {
        scrollDirection = .horizontal
        itemSize = CGSize(width: UIScreen.main.bounds.width / 2.5, height: UIScreen.main.bounds.height / 3.5)
        sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        minimumLineSpacing = 40
    }
}


class TrackItemsFlowLayout: UICollectionViewFlowLayout {
    
    func setup() {
        scrollDirection = .vertical
        itemSize = CGSize(width: UIScreen.main.bounds.width / 3.4, height: UIScreen.main.bounds.height / 5.4)
        sectionInset = UIEdgeInsets(top: 0, left: 12, bottom: 20, right: 12)
        minimumLineSpacing = 20
    }
    
}


class MediaCollectionDataSource: BaseMediaControllerDataSource {
    
    let store = SearchResultsFetcher()
    
    var items = [PodcastSearchResult]()
    
    var viewShown: ShowView {
        guard let casters = casters else { return .empty }
        if casters.count > 0 {
            return .collection
        } else {
            return .empty
        }
    }
}

extension MediaCollectionDataSource: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    fileprivate func setTrackCell(indexPath: IndexPath, cell: TrackCell, rowTime: Double) {
        if let urlString = items[indexPath.row].podcastArtUrlString,
            let url = URL(string: urlString),
            let title = items[indexPath.row].podcastTitle {
            let cellViewModel = TrackCellViewModel(trackName: title, albumImageUrl: url)
            cell.configureCell(with: cellViewModel, withTime: 0)
            DispatchQueue.main.asyncAfter(deadline: .now() + rowTime) {
                UIView.animate(withDuration: rowTime) {
                    cell.alpha = 1
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as TrackCell
        cell.alpha = 0
        var rowTime: Double = 0
        if indexPath.row > 10 {
            rowTime = (Double(indexPath.row % 10)) / 10
        } else {
            rowTime = (Double(indexPath.row)) / 10
        }
        
        cell.layer.cornerRadius = 3
        setTrackCell(indexPath: indexPath, cell: cell, rowTime: rowTime)
        return cell
    }
}
