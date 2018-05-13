//
//  SearchItemsFlowLayout.swift
//  PodCatcher
//
//  Created by Christopher Webb-Orenstein on 1/16/18.
//  Copyright © 2018 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

final class SearchItemsFlowLayout: UICollectionViewFlowLayout {
    
    func setup() {
        scrollDirection = .vertical
        itemSize = CGSize(width: UIScreen.main.bounds.width / 1.01, height: UIScreen.main.bounds.height / 7.4)
        sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        minimumLineSpacing = 1
    }
}

