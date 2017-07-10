import UIKit

class SearchControllerDataSource: NSObject {
    let store =  SearchResultsFetcher()
    var items = [PodcastSearchResult]()
    var emptyView = EmptyView(frame: UIScreen.main.bounds)
}

extension SearchControllerDataSource: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if items.count <= 0 {
            tableView.backgroundView = UIView(frame: UIScreen.main.bounds)
            tableView.backgroundView?.addSubview(emptyView)
        } else {
            emptyView.removeFromSuperview()
        }
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as SearchResultCell
        if items.count > 0 {
            if let title = items[indexPath.row].podcastTitle, let urlString = items[indexPath.row].podcastArtUrlString, let url = URL(string: urlString)  {
                cell.titleLabel.text = title
                cell.albumArtView.downloadImage(url: url)
                cell.layoutSubviews()
            }
        }
        return cell
    }
}
