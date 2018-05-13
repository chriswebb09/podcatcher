//
//  BrowseTopCollectionViewControllerDelegate.swift
//  PodCatcher
//
//  Created by Christopher Webb on 5/13/18.
//  Copyright © 2018 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

protocol BrowseTopCollectionViewControllerDelegate: class {
    func topItems(loaded: Bool)
    func goToEpisodeList(podcast: Podcast, at index: Int, with imageView: UIImageView)
}
