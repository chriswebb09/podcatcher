import UIKit

class HomeCollectionDataSource: BaseMediaControllerDataSource {
    
    let store = SearchResultsDataStore()
    
    var lookup: String = ""
    
    var items = [CasterSearchResult]()
    
    var topViewItemIndex: Int = 0
    
    var reserveItems = [CasterSearchResult]()
    
    var categories: [String] = []
    
    var viewShown: ShowView {
        guard let casters = casters else { return .empty }
        if casters.count > 0 {
            return .collection
        } else {
            return .empty
        }
    }
    
    func searchForTracks(completion: @escaping (_ results: [CasterSearchResult]? , _ error: Error?) -> Void) {
        iTunesAPIClient.search(forLookup: lookup) { response in
            switch response {
            case .success(let data):
                let resultsData = data["results"] as! [[String: Any]]
                let results = ResultsParser.parse(resultsData: resultsData)
                DispatchQueue.main.async {
                    completion(results, nil)
                }
            case .failed(let error):
                completion(nil, error)
            }
        }
    }
}

extension HomeCollectionDataSource:  UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    fileprivate func setCell(indexPath: IndexPath, cell: TopPodcastCell, rowTime: Double) {
        if let urlString = items[indexPath.row].podcastArtUrlString,
            let url = URL(string: urlString),
            let title = items[indexPath.row].podcastTitle {
            let cellViewModel = TopPodcastCellViewModel(trackName: title, albumImageUrl: url)
            cell.configureCell(with: cellViewModel, withTime: 0)
            DispatchQueue.main.asyncAfter(deadline: .now() + rowTime) {
                UIView.animate(withDuration: rowTime) {
                    cell.alpha = 1
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 || indexPath.row == 1 {
            reserveItems.append(items[indexPath.row])
        }
        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as TopPodcastCell
        let rowTime: Double = 0
        cell.layer.cornerRadius = 3
        setCell(indexPath: indexPath, cell: cell, rowTime: rowTime)
        return cell
    }
}
