//
//  HomeViewControllerConstants.swift
//  PodCatcher
//
//  Created by Christopher Webb on 5/12/18.
//  Copyright © 2018 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit
import CoreData

struct HomeViewControllerConstants {
    static let minimumLineSpacingForSectionAt: CGFloat = 4
    static let minimumInteritemSpacingForSectionAt: CGFloat = 1.0
    static let insetForSectionAt: UIEdgeInsets = UIEdgeInsets(top: 1, left: 4, bottom: 2, right: 4)
    static let sizeForItemAt: CGSize = CGSize(width:UIScreen.main.bounds.width / 3.12, height: UIScreen.main.bounds.height / 6.4)
    static let cellTransform: CGAffineTransform = CGAffineTransform(scaleX: 0.7, y: 0.7)
    static let cellTransformFinished: CGAffineTransform = CGAffineTransform(scaleX: 1, y: 1)
}
