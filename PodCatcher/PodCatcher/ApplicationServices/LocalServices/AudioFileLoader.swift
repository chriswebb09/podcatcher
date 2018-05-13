//
//  AudioFileLoader.swift
//  PodCatcher
//
//  Created by Christopher Webb on 5/12/18.
//  Copyright © 2018 Christopher Webb-Orenstein. All rights reserved.
//

import Foundation
import AVFoundation


protocol AudioFileLoader: class {
    var player: AVPlayer? { get set }
    func play(episode: Episodes)
    func play()
}

extension AudioFileLoader {
    func play(episode: Episodes) {
        
        try? AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
        try? AVAudioSession.sharedInstance().setActive(true)
        NotificationCenter.default.post(name: .audioPlayerWillStartPlaying, object: self, userInfo: [
            AudioPlayerEpisodeUserInfoKey: episode
            ])
        guard let url = URL(string: episode.mediaUrlString) else { return }
        self.player = AVPlayer(url: url)
        self.play()
    }
    
    func play() {
        self.player?.play()
    }
}
