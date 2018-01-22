import Foundation
import AVFoundation


enum PlayerState {
    case playing, paused, stopped
}

@objc final class AudioFilePlayer: NSObject {
    
    // MARK: Properties
    
    static let assetKeysRequiredToPlay = [
        "playable",
        "hasProtectedContent"
    ]
    
    @objc var player: AVPlayer? = AVPlayer()
    
    var currentTime: Double? {
        get {
            guard let player = player else { return 0 }
            return CMTimeGetSeconds(player.currentTime())
        }
        set {
            guard let newValue = newValue else { return }
            let newTime = CMTimeMakeWithSeconds(newValue, 1)
            guard let player = player else { return }
            player.seek(to: newTime, toleranceBefore: kCMTimeZero, toleranceAfter: kCMTimeZero)
        }
    }
    
    var duration: Double {
        guard let currentItem = player?.currentItem else { return 0.0 }
        return CMTimeGetSeconds(currentItem.duration)
    }
    
    var rate: Float {
        get {
            guard let player = player else { return 0 }
            return player.rate
        }
        
        set {
            player?.rate = newValue
        }
    }
    
    var asset: AVURLAsset? {
        didSet {
            guard let newAsset = asset else { return }
            asynchronouslyLoadURLAsset(newAsset)
        }
    }
    
    weak var delegate: AudioFilePlayerDelegate?
    
    var state: PlayerState? = .stopped
    
    var playerItem: AVPlayerItem? = nil {
        didSet {
            player?.replaceCurrentItem(with: self.playerItem)
        }
    }
    
    override init() {
        // self.player = AVPlayer()
        super.init()
    }
    
    func playPause() {
        if player?.rate != 1.0 {
            state = .playing
            if currentTime == duration {
                currentTime = 0.0
            }
            
            player?.playImmediately(atRate: 1)
        } else {
            state = .paused
            player?.pause()
        }
    }
    
    func play() {
        if player?.rate != 1.0 {
            if currentTime == duration {
                // At end, so got back to begining.
                currentTime = 0.0
            }
            
            player?.playImmediately(atRate: 1)
        }
        else {
            // Playing, so pause.
            player?.pause()
        }
        state = .playing
    }
    
    func pause() {
        if player?.rate != 1.0 {
            // Not playing forward, so play.
            if currentTime == duration {
                // At end, so got back to begining.
                currentTime = 0.0
            }
            
            player?.play()
        }
        else {
            
            player?.pause()
        }
        state = .paused
    }
}

extension AudioFilePlayer: AVAssetResourceLoaderDelegate {
    
    // MARK: - Asset Loading
    
    func asynchronouslyLoadURLAsset(_ newAsset: AVURLAsset?) {
        
        guard let newAsset = newAsset else { return }
        
        print("Loading async")
        
        newAsset.loadValuesAsynchronously(forKeys: AudioFilePlayer.assetKeysRequiredToPlay) { [weak self] in
            guard let strongSelf = self else { return }
            DispatchQueue.main.async {
                
                guard newAsset == strongSelf.asset else { return }
                for key in AudioFilePlayer.assetKeysRequiredToPlay {
                    var error: NSError?
                    print(key.description)
                    if newAsset.statusOfValue(forKey: key, error: &error) == .failed {
                        let stringFormat = NSLocalizedString("error.asset_key_%@_failed.description", comment: "Can't use this AVAsset because one of it's keys failed to load")
                        let message = String.localizedStringWithFormat(stringFormat, key)
                        print("async load error: \(message)")
                        return
                    }
                }
                if !newAsset.isPlayable || newAsset.hasProtectedContent {
                    let message = NSLocalizedString("error.asset_not_playable.description", comment: "Can't use this AVAsset because it isn't playable or has protected content")
                    print("async load error: \(message)")
                    return
                }
                strongSelf.playerItem = AVPlayerItem(asset: newAsset)
            }
        }
    }
}

