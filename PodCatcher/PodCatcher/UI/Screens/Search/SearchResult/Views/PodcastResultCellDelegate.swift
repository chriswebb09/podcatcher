//
//  PodcastResultCellDelegate.swift
//  PodCatcher
//
//  Created by Christopher Webb on 5/12/18.
//  Copyright © 2018 Christopher Webb-Orenstein. All rights reserved.
//

import Foundation

protocol PodcastResultCellDelegate: class {
    func moreButtonTapped(sender: Any, cell: PodcastListCell)
}
