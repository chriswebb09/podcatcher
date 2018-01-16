//
//  SearchResultDatasource.swift
//  PodCatcher
//
//  Created by Christopher Webb-Orenstein on 1/11/18.
//  Copyright © 2018 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

class SearchResultDatasource: NSObject {
    private var item: CasterSearchResult!
    
    func setItem(item: CasterSearchResult) {
        self.item = item
    }
}

extension SearchResultDatasource: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return item.episodes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as PodcastResultCell
        DispatchQueue.main.async {
            if let playTime = self.item.episodes[indexPath.row].stringDuration {
                let model = PodcastResultCellViewModel(podcastTitle: self.item.episodes[indexPath.row].title, playtimeLabel: playTime)
                cell.configureCell(model: model)
            }
        }
        return cell
    }
}
