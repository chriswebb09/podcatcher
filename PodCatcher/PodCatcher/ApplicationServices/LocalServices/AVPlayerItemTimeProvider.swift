//
//  AVPlayerItemTimeProvider .swift
//  PodCatcher
//
//  Created by Christopher Webb on 5/12/18.
//  Copyright © 2018 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit
import AVFoundation

protocol AVPlayerItemTimeProvider {
    func currentTime() -> CMTime
    var duration: CMTime { get }
}

extension AVPlayerItemTimeProvider {
    var timeElapsed: Double {
        return self.currentTime().seconds
    }
    
    var timeRemaining: Double {
        return self.duration.seconds - self.timeElapsed
    }
}

extension AVPlayerItem: AVPlayerItemTimeProvider {}


