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
        index -= 1
    }
    
    func skipButtonTapped() {
        index += 1
    }
    
    func pauseButtonTapped() {
        
    }
    
    func playButtonTapped() {
        player.play(player: player.player)
    }
}

extension PlayerViewController: TrackPlayerDelegate {
    
    func trackFinishedPlaying() {
        
    }

    func trackDurationCalculated(stringTime: String, timeValue: Float64) {
        DispatchQueue.main.async {
            self.playerViewModel.totalTime = stringTime
            self.setModel(model: self.playerViewModel)
        }
        
        print(stringTime)
        print(timeValue)
    }

    func updateProgress(progress: Double) {
        print(progress)
    }

    
}
