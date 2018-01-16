//
//  CollectionController.swift
//  PodCatcher
//
//  Created by Christopher Webb-Orenstein on 1/11/18.
//  Copyright © 2018 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

class CollectionController<Model: Codable, Cell: UICollectionViewCell>: UICollectionViewController {
    
    var items = [Model]()
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
    }
    
    @objc private func handleRefresh() {
        refreshControl.endRefreshing()
        loadData()
    }
    
    // MARK: - Subclass
    
    func loadData() {
        // Subclass to decide
    }
    
    func configure(cell: Cell, model: Model) {
        // Subclass to decide
    }
    
    // MARK: - UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! Cell
        let item = items[indexPath.row]
        configure(cell: cell, model: item)
        
        return cell
    }
}


