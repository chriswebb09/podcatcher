//
//  DownloadCellDelegate.swift
//  PodCatcher
//
//  Created by Christopher Webb on 5/13/18.
//  Copyright © 2018 Christopher Webb-Orenstein. All rights reserved.
//

import Foundation

protocol DownloadCellDelegate: class {
    func moreButtonTapped(sender: Any, cell: DownloadedCell)
    func playButton(tapped:Bool)
    func pauseButton(tapped: Bool)
}
