//
//  PlayerViewController+Extension.swift
//  PodCatcher
//
//  Created by Christopher Webb-Orenstein on 6/7/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

// MARK: - PlayerViewDelegate

extension PlayerViewController: PlayerViewDelegate {
    
    func backButtonTapped() {
        guard var index = index else { return }
        index -= 1
    }
    
    func skipButtonTapped() {
        guard var index = index, index > 0 else { return }
        index += 1
    }
    
    func pauseButtonTapped() {
        
    }
    
    func playButtonTapped() {
        
    }
}
