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
        guard let player = player else { return }
        player.currentTime = time
        DispatchQueue.main.async {
            let normalizedTime = player.currentTime * 100.0 / player.duration
            let timeString = String.constructTimeString(time: player.currentTime)
            self.playerView.currentPlayTimeLabel.text = timeString
            self.playerView.update(progressBarValue: Float(normalizedTime))
        }
    }
    
    func backButtonTapped() {
        guard index > 0 else { return }
        index -= 1
        delegate?.skipButtonTapped()
    }
    
    func skipButtonTapped() {
        guard index <= caster.assets.count else { return }
        index += 1
    }
    
    func pauseButtonTapped() {
        guard let player = player else { return }
        player.player.pause()
        delegate?.pauseButtonTapped()
    }
    
    func playButtonTapped() {
        guard let player = player else { return }
        player.delegate = self
        player.play(player: player.player)
        player.observePlayTime()
        delegate?.playButtonTapped()
    }
}

extension PlayerViewController: AudioFilePlayerDelegate {
    
    func trackFinishedPlaying() {
        print("Finished")
    }
    
    func trackDurationCalculated(stringTime: String, timeValue: Float64) {
        DispatchQueue.main.async {
            self.playerViewModel.totalTimeString = stringTime
            self.setModel(model: self.playerViewModel)
        }
    }
    
    func updateProgress(progress: Double) {
        guard let player = player else { return }
        let normalizedTime = player.currentTime * 100.0 / player.duration
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.playerView.currentPlayTimeLabel.text = String.constructTimeString(time: player.currentTime)
            strongSelf.playerView.update(progressBarValue: Float(normalizedTime))
        }
    }
}
