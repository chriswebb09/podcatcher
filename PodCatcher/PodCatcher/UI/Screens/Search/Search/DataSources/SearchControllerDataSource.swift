import UIKit

final class PodcastSearchResultLoadOperation: Operation {
    var topItem: PodcastSearchResult?
    var loadingCompleteHandler: ((PodcastSearchResult) -> ())?
    
    private let _topItem: PodcastSearchResult
    
    init(_ topItem: PodcastSearchResult) {
        _topItem = topItem
    }
    
    override func main() {
        if isCancelled { return }
        self.topItem = _topItem
        
        if let loadingCompleteHandler = loadingCompleteHandler {
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else { return }
                loadingCompleteHandler(strongSelf._topItem)
            }
        }
    }
}

final class SearchControllerDataSource: NSObject {
    
    var interactor =  SearchResultsIteractor()
    var items = [PodcastSearchResult]()
    let loadingQueue = OperationQueue()
    fileprivate var sections: [String] = []
    var loadingOperations = [IndexPath : PodcastSearchResultLoadOperation]()
    var viewShown: ShowView {
        if items.count > 0 {
            return .collection
        } else {
            return .empty
        }
    }
    
    var emptyView = NoSearchResultsView()
    
    func podcastForItemAtIndexPath(_ indexPath: IndexPath) -> PodcastSearchResult? {
        return items[indexPath.row]
    }
    
}

extension SearchControllerDataSource: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as SearchResultCell
        if items.count > 0 {
            if let title = items[indexPath.row].podcastTitle, let urlString = items[indexPath.row].podcastArtUrlString, let url = URL(string: urlString)  {
                cell.alpha = 0
                cell.configureCell(with: url, title: title)
                UIView.animate(withDuration: 0.016, animations: {
                    cell.alpha = 1
                })
            }
        }
        return cell
    }
}

extension  SearchControllerDataSource: UITableViewDataSourcePrefetching {
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            if let _ = loadingOperations[indexPath] { return }
            if let topPocast = podcastForItemAtIndexPath(indexPath) {
                let dataLoader = PodcastSearchResultLoadOperation(topPocast)
                loadingQueue.addOperation(dataLoader)
                loadingOperations[indexPath] = dataLoader
            }
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as SearchResultCell
        if items.count > 0 {
            if let title = items[indexPath.row].podcastTitle, let urlString = items[indexPath.row].podcastArtUrlString, let url = URL(string: urlString)  {
                DispatchQueue.main.async {
                    cell.configureCell(with: url, title: title)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let dataLoader = loadingOperations[indexPath] {
            dataLoader.cancel()
            loadingOperations.removeValue(forKey: indexPath)
        }
        
    }
    
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            if let dataLoader = loadingOperations[indexPath] {
                dataLoader.cancel()
                loadingOperations.removeValue(forKey: indexPath)
            }
        }
    }
}
