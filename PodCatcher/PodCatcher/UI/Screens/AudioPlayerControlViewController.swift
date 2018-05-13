//
//  AudioPlayerControlViewController.swift
//  PodCatcher
//
//  Created by Christopher Webb on 5/13/18.
//  Copyright © 2018 Christopher Webb-Orenstein. All rights reserved.
//

import Foundation
import UIKit

class AudioPlayerControlViewController: UIViewController, PodcastSubscriber {
    
    //  MARK: - Properties
    
    var currentPodcast: Episodes?
    
    @IBOutlet var audioPlayerControlsView: AudioPlayerControlsView!
    
    weak var delegate: AudioPlayerControlViewControllerDelegate?
    
    var currentState: AudioState = .stopped
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {
            self.audioPlayerControlsView.playtimeSlider.minimumValue = 0
            self.audioPlayerControlsView.playtimeSlider.setValue(0, animated: true)
            self.audioPlayerControlsView.playtimeSlider.maximumValue = 1
            self.audioPlayerControlsView.currentPodcast = self.currentPodcast
            self.audioPlayerControlsView.currentState = self.currentState
            self.audioPlayerControlsView.delegate = self
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        audioPlayerControlsView.setup()
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            NotificationCenter.default.addObserver(self, selector: #selector(audioPlayerDidStartLoading(_:)), name: .audioPlayerDidStartLoading, object: appDelegate.audioPlayer)
            NotificationCenter.default.addObserver(self, selector: #selector(audioPlayerDidStartPlaying(_:)), name: .audioPlayerDidStartPlaying, object: appDelegate.audioPlayer)
            NotificationCenter.default.addObserver(self, selector: #selector(audioPlayerDidPause(_:)), name: .audioPlayerDidPause, object: appDelegate.audioPlayer)
            
            NotificationCenter.default.addObserver(self, selector: #selector(audioPlayerPlaybackTimeChanged(_:)), name: .audioPlayerPlaybackTimeChanged, object: appDelegate.audioPlayer)
        }
    }
    
    func audioPlayerWillStartPlaying(_ notification: Notification) {
        print(notification)
        
    }
    
    @objc private func audioPlayerDidStartLoading(_ notification: Notification) {
        print(notification)
    }
    
    @objc private func audioPlayerDidStartPlaying(_ notification: Notification) {
        print(notification)
    }
    
    @objc private func audioPlayerDidPause(_ notification: Notification) {
    }
    
    @objc private func audioPlayerPlaybackTimeChanged(_ notification: Notification) {
        let secondsElapsed = notification.userInfo![AudioPlayerSecondsElapsedUserInfoKey]! as! Double
        let secondsRemaining = notification.userInfo![AudioPlayerSecondsRemainingUserInfoKey]! as! Double
        print(secondsElapsed)
        print(secondsRemaining)
        
        DispatchQueue.main.async {
            if !secondsRemaining.isNaN {
                self.audioPlayerControlsView.playtimeSlider.maximumValue = Float(secondsRemaining + secondsElapsed)
            }
            self.audioPlayerControlsView.timeLeftLabel.text =   String.constructTimeString(time: secondsRemaining)
            self.audioPlayerControlsView.timePlayedLabel.text = String.constructTimeString(time: secondsElapsed)
            self.audioPlayerControlsView.playtimeSlider.setValue(Float(secondsElapsed), animated: true)
        }
    }
}

// MARK: - Internal
extension AudioPlayerControlViewController: AudioPlayerControlsViewDelegate {
    func sliderValue(set: Double) {
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            guard let currentTime = appDelegate.audioPlayer.currentTime else { return }
            if set < currentTime {
                let diff = currentTime - set
                appDelegate.audioPlayer.skip(by: -diff)
            } else {
                appDelegate.audioPlayer.skip(by: set)
            }
        }
    }
    
    func dismiss(tapped: Bool) {
        delegate?.dismiss(tapped: true)
    }
    
    func playButton(tapped: Bool) {
        print("play")
        delegate?.playButton(tapped: true)
    }
    
    func pauseButton(tapped: Bool) {
        delegate?.pauseButton(tapped: true)
    }
    
    func skipButton(tapped: Bool) {
        delegate?.skipButton(tapped: true)
    }
    
    func backButton(tapped: Bool) {
        delegate?.backButton(tapped: true)
    }
}
