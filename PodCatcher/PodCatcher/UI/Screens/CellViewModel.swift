//
//  CellViewModel.swift
//  PodCatcher
//
//  Created by Christopher Webb on 5/13/18.
//  Copyright © 2018 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

protocol CellViewModel: class {
    var titleText: String! { get set }
    var mainImage: UIImage! { get set }
}

extension CellViewModel {
    
    func configure(titleText: String, mainImage: UIImage) {
        self.titleText = titleText
        self.mainImage = mainImage
    }
}

