import UIKit

final class SearchControllerDataSource: NSObject {
    
    var store =  SearchResultsFetcher()
    var items = [PodcastSearchResult]()
    
    var viewShown: ShowView {
        if items.count > 0 {
            return .collection
        } else {
            return .empty
        }
    }
    
    var emptyView = NoSearchResultsView()
}

extension SearchControllerDataSource: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as SearchResultCell
        if items.count > 0 {
            if let title = items[indexPath.row].podcastTitle, let urlString = items[indexPath.row].podcastArtUrlString, let url = URL(string: urlString)  {
                DispatchQueue.main.async {
                    cell.titleLabel.text = title
                    cell.albumArtView.downloadImage(url: url)
                    cell.layoutSubviews()
                }
              
            }
        }
        cell.albumArtView.layer.cornerRadius = 5
        return cell
    }
}
