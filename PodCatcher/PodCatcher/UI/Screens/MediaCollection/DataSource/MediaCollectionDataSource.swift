import UIKit

class MediaCollectionDataSource: BaseMediaControllerDataSource {
    
    let store = TrackDataStore()
    
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
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as MediaCell
        if let casters = casters, let artWork = casters[indexPath.row].podcastArtUrlString, let name = casters[indexPath.row].podcastArtist {
            UIImage.downloadImageFromUrl(artWork) { image in
                guard let image = image else { return }
                let model = MediaCellViewModel(trackName: name, albumImageURL: image)
                DispatchQueue.main.async {
                    cell.configureCell(with: model, withTime: (Double(indexPath.row) * 0.01))
                }
            }            
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return count
    }
}
