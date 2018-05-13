//
//  SearchResultDatasource.swift
//  PodCatcher
//
//  Created by Christopher Webb-Orenstein on 1/11/18.
//  Copyright © 2018 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

class SearchResultDatasource: NSObject {
    
    private var models: [PodcastResultCellViewModel]!
    
    var controller: PodcastListViewController!
    
    var animateCellAtIndex: IndexPath!
    func set(models: [PodcastResultCellViewModel]) {
        self.models = models
    }
}

extension SearchResultDatasource: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let models = models {
            return models.count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PodcastListCell.reuseIdentifier, for: indexPath) as! PodcastListCell
        DispatchQueue.main.async { [weak self] in
            if let strongSelf = self {
                let model = strongSelf.models[indexPath.row]
                cell.configureCell(model: model)
                cell.delegate = strongSelf.controller
                if self?.animateCellAtIndex == indexPath {
                    cell.setupAudio()
                } else {
                    if let animation = cell.audioAnimation {
                        if animation.isAnimating {
                            cell.removeAudio()
                        }
                    }
                }
            }
        }
        return cell
    }
}
