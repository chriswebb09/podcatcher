//
//  SearchControllerDataSource.swift
//  Podcatch
//
//  Created by Christopher Webb-Orenstein on 2/3/18.
//  Copyright © 2018 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

final class SearchControllerDataSource: NSObject {
    
    var interactor =  SearchResultsIteractor()
    
    var items = [Podcast]()
    
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
    
    func podcastForItemAtIndexPath(_ indexPath: IndexPath) -> Podcast? {
        return items[indexPath.row]
    }
    
}

extension SearchControllerDataSource: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultCell.reuseIdentifier, for: indexPath) as! SearchResultCell
        if items.count > 0 {
            if let url = URL(string: items[indexPath.row].podcastArtUrlString)  {
                cell.alpha = 0
                cell.configureCell(with: url, title:  items[indexPath.row].podcastTitle)
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
            if let topPocast = podcastForItemAtIndexPath(indexPath) {
                let dataLoader = PodcastSearchResultLoadOperation(topPocast)
                loadingQueue.addOperation(dataLoader)
                loadingOperations[indexPath] = dataLoader
            }
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultCell.reuseIdentifier, for: indexPath) as! SearchResultCell
        if items.count > 0 {
            if let url = URL(string: items[indexPath.row].podcastArtUrlString)  {
                DispatchQueue.main.async {
                    cell.configureCell(with: url, title: self.items[indexPath.row].podcastTitle)
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
