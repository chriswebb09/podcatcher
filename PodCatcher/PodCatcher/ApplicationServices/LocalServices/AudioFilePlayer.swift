

enum PlayerState {
    case playing, paused, stopped
}

import Foundation
import AVFoundation

extension Notification.Name {
    static let audioPlayerWillStartPlaying = Notification.Name("audioPlayerWillStartPlaying")
    static let audioPlayerDidStartLoading = Notification.Name("audioPlayerDidStartLoading")
    static let audioPlayerDidStartPlaying = Notification.Name("audioPlayerDidStartPlaying")
    static let audioPlayerDidPause = Notification.Name("audioPlayerDidPause")
    static let audioPlayerPlaybackTimeChanged = Notification.Name("audioPlayerPlaybackTimeChanged")
}


let AudioPlayerEpisodeUserInfoKey = "AudioPlayerEpisodeUserInfoKey"
let AudioPlayerSecondsElapsedUserInfoKey = "AudioPlayerSecondsElapsedUserInfoKey"
let AudioPlayerSecondsRemainingUserInfoKey = "AudioPlayerSecondsRemainingUserInfoKey"

@objc final class AudioFilePlayer: NSObject, AudioFileLoader {
    
    // MARK: Properties
    
    static let assetKeysRequiredToPlay = [
        "playable",
        "hasProtectedContent"
    ]
    
    private var timeObserver: Any?
    private var timeControlStatusObserver: NSKeyValueObservation?
    
    var audioPlayer: AVAudioPlayer?
    
    internal var player: AVPlayer? {
        willSet {
            self.timeObserver.map {
                self.player?.removeTimeObserver($0)
            }
            self.timeControlStatusObserver?.invalidate()
            self.timeControlStatusObserver = nil
        }
        didSet {
            self.timeObserver = self.player?.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1.0, preferredTimescale: 1), queue: DispatchQueue.main, using: { [weak self] _ in
                guard let strongSelf = self, let item = strongSelf.player?.currentItem else {
                    return
                }
//                NotificationCenter.default.post(name: .audioPlayerPlaybackTimeChanged, object: strongSelf, userInfo: [
//                    AudioPlayerSecondsElapsedUserInfoKey: item.timeElapsed,
//                    AudioPlayerSecondsRemainingUserInfoKey: item.timeRemaining,
//                    ])
            })
            self.timeControlStatusObserver = self.player?.observe(\.timeControlStatus) { player, change in
                switch player.timeControlStatus {
                case .waitingToPlayAtSpecifiedRate:
                    NotificationCenter.default.post(name: .audioPlayerDidStartLoading, object: self, userInfo: nil)
                case .playing:
                    NotificationCenter.default.post(name: .audioPlayerDidStartPlaying, object: self, userInfo: nil)
                case .paused:
                    NotificationCenter.default.post(name: .audioPlayerDidPause, object: self, userInfo: nil)
                }
            }
        }
    }
    
    //    @objc var player: AVPlayer? = AVPlayer()
    
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
    
    
    var isPlaying: Bool {
        if (self.rate != 0) {
            return true
        } else {
            return false
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
    
    func pause() {
        self.player?.pause()
    }
    
    func showPlaybackFailedErrorAlert(error: Error) {
        print(error.localizedDescription)
    }
    
    func skip(by seconds: Double) {
        self.player?.skip(by: seconds)
    }
    
    func playAudioWithData(audioData: NSData) {
        do {
            self.audioPlayer = try AVAudioPlayer(data: audioData as Data)
        } catch let error as Error {
            
            self.showPlaybackFailedErrorAlert(error: error)
            self.player = nil
        } catch {
            self.showGenericErrorAlert(altertString: "Playback Failed.")
            self.player = nil
        }
    }
    
    func showGenericErrorAlert(altertString: String) {
        
    }
    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        do { try AVAudioSession.sharedInstance().setActive(false) } catch { }
        self.player = nil
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
