//
//  PodcastCollectionViewProtocol.swift
//  PodCatcher
//
//  Created by Christopher Webb-Orenstein on 6/10/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

protocol PodcastCollectionViewProtocol: class {
    var collectionView: UICollectionView { get set }
}

extension PodcastCollectionViewProtocol {
    
    func setup(dataSource: UICollectionViewDataSource, delegate: UICollectionViewDelegate) {
        collectionView.dataSource = dataSource
        collectionView.delegate = delegate
        collectionView.register(PodcastCell.self)
        collectionView.backgroundColor = PodcastListConstants.backgroundColor
    }
}
