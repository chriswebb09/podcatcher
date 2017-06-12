//
//  PlayerViewController+Extension.swift
//  PodCatcher
//
//  Created by Christopher Webb-Orenstein on 6/7/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit
import CoreMedia

// MARK: - PlayerViewDelegate

extension PlayerViewController: PlayerViewDelegate {
    func updateTimeValue(time: Double) {
        print("Time mult \(time * 200)")
        var timeTrans = CMTime(value: CMTimeValue(time * 100), timescale: 1)
        player.player.seek(to: timeTrans)
        print("Updated time \(time)")
        print("Updated trans time \(timeTrans.value)")
        DispatchQueue.main.async {
            self.playerView.updateProgressBar(value: time / 100)
        }
    }

    
    func backButtonTapped() {
        index -= 1
    }
    
    func skipButtonTapped() {
        index += 1
    }
    
    func pauseButtonTapped() {
        player.player.pause()
    }
    
    func playButtonTapped() {
        player.play(player: player.player)
        player.observePlayTime()
    }
}

extension PlayerViewController: TrackPlayerDelegate {
    
    func trackFinishedPlaying() {
        
    }
    
    func trackDurationCalculated(stringTime: String, timeValue: Float64) {
        DispatchQueue.main.async {
            self.playerViewModel.totalTimeString = stringTime
            self.playerViewModel.playTimeIncrement = self.playerViewModel.playTimeIncrement / Float(timeValue)
            self.setModel(model: self.playerViewModel)
        }
        
    }
    
    func updateProgress(progress: Double) {
        print(progress)
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.playerView.updateProgressBar(value: progress)
        }
    }
    
    
}
