//
//  AVPlayerSkipProvider.swift
//  PodCatcher
//
//  Created by Christopher Webb on 5/12/18.
//  Copyright © 2018 Christopher Webb-Orenstein. All rights reserved.
//

import AVFoundation

protocol AVPlayerSkipProvider {
    func currentTime() -> CMTime
    func seek(to time: CMTime)
}

extension AVPlayerSkipProvider {
    func skip(by seconds: Double) {
        let seconds = self.currentTime().seconds + seconds
        let time = CMTime(seconds: seconds, preferredTimescale: 1)
        self.seek(to: time)
    }
}

extension AVPlayer: AVPlayerSkipProvider {}
