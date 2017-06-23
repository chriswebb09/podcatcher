import UIKit

class PodcastListDataSource: BaseMediaControllerDataSource {
    
    var index: Int!
    
    var caster: Caster!
    
    var viewShown: ShowView {
        if casters.count > 0 {
            return .collection
        } else {
            return .empty
        }
    }
    
    let updatedTopViewFrame = CGRect(x: 0,
                                     y: 0,
                                     width: PodcastListConstants.topFrameWidth,
                                     height: PodcastListConstants.topFrameHeight / 1.2)
}

extension PodcastListDataSource: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as PodcastCell
        if let artwork = caster.artwork {
            let model = PodcastCellViewModel(podcastImage: artwork, podcastTitle: caster.assets[indexPath.row].title, item: caster.assets[indexPath.row])
            cell.configureCell(model: model)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return caster.assets.count
    }
}
