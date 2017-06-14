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
        
        let newTime = CMTime(seconds: time, preferredTimescale: 1)
        player.player.seek(to: newTime)
        
        DispatchQueue.main.async {
            let normalizedTime = Float(self.player.currentTime * 100.0 / self.player.duration)
            let string = self.playerViewModel.constructTimeString(time: Int(normalizedTime))
            self.playerView.currentPlayTimeLabel.text = string
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
        player.delegate = self
        player.play(player: player.player)
        player.observePlayTime()
    }
}

extension PlayerViewController: AudioFilePlayerDelegate {
    
    func trackFinishedPlaying() {
        print("Finished")
    }
    
    func trackDurationCalculated(stringTime: String, timeValue: Float64) {
        DispatchQueue.main.async {
            self.playerViewModel.totalTimeString = stringTime
            self.playerViewModel.playTimeIncrement = self.playerViewModel.playTimeIncrement / Float(timeValue)
            self.setModel(model: self.playerViewModel)
        }
    }
    
    func updateProgress(progress: Double) {
        let normalizedTime = Float(player.currentTime * 100.0 / player.duration)
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.playerView.update(progressBarValue: normalizedTime)
        }
    }
}
