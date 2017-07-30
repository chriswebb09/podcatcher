import Foundation
import AVFoundation

public struct NotificationDescriptor<A> {
    let name: Notification.Name
    let convert: (Notification) -> A
}

public extension AVPlayerItem {
    static let didPlayToEndTime = NotificationDescriptor<()>(name: .AVPlayerItemDidPlayToEndTime) { _ in () }
}

enum PlayerState {
    case playing, paused, stopped
}

//private var playerViewControllerKVOContext = 0

final class AudioFilePlayer: NSObject {
    // MARK: Properties
    
    // Attempt load and test these asset keys before playing.
    static let assetKeysRequiredToPlay = [
        "playable",
        "hasProtectedContent"
    ]
    
    let player = AVPlayer()
    
    var currentTime: Double {
        get {
            return CMTimeGetSeconds(player.currentTime())
        }
        set {
            let newTime = CMTimeMakeWithSeconds(newValue, 1)
            player.seek(to: newTime, toleranceBefore: kCMTimeZero, toleranceAfter: kCMTimeZero)
        }
    }
    
    var duration: Double {
        guard let currentItem = player.currentItem else { return 0.0 }
        
        return CMTimeGetSeconds(currentItem.duration)
    }
    
    var rate: Float {
        get {
            return player.rate
        }
        
        set {
            player.rate = newValue
        }
    }
    
    var asset: AVURLAsset? {
        didSet {
            guard let newAsset = asset else { return }
            
            asynchronouslyLoadURLAsset(newAsset)
        }
    }
    
    weak var delegate: AudioFilePlayerDelegate?
    var state: PlayerState = .stopped
    
    
    var timeObserver: Any?
    //
    var playerItem: AVPlayerItem? = nil {
        didSet {
            player.replaceCurrentItem(with: self.playerItem)
        }
    }
    
    
    override init() {
        // self.player = AVPlayer()
        super.init()
    }
    
    func playPause() {
        if player.rate != 1.0 {
            state = .playing
            // Not playing forward, so play.
            if currentTime == duration {
                // At end, so got back to begining.
                currentTime = 0.0
            }
            
            player.play()
        } else {
            state = .paused
            // Playing, so pause.
            player.pause()
        }
    }
    
    func play() {
        if player.rate != 1.0 {
            // Not playing forward, so play.
            if currentTime == duration {
                // At end, so got back to begining.
                currentTime = 0.0
            }
            
            player.play()
        }
        else {
            // Playing, so pause.
            player.pause()
        }
        state = .playing
    }
    
    func pause() {
        if player.rate != 1.0 {
            // Not playing forward, so play.
            if currentTime == duration {
                // At end, so got back to begining.
                currentTime = 0.0
            }
            
            player.play()
        }
        else {
            // Playing, so pause.
            player.pause()
        }
        state = .paused
    }
    
    func removePeriodicTimeObserver() {
        guard let token = timeObserver else { return }
        player.removeTimeObserver(token)
        timeObserver = nil
    }
}

extension AudioFilePlayer: AVAssetResourceLoaderDelegate {
    
    // MARK: - Asset Loading
    
    func asynchronouslyLoadURLAsset(_ newAsset: AVURLAsset) {
        /*
         Using AVAsset now runs the risk of blocking the current thread (the
         main UI thread) whilst I/O happens to populate the properties. It's
         prudent to defer our work until the properties we need have been loaded.
         */
        newAsset.loadValuesAsynchronously(forKeys: AudioFilePlayer.assetKeysRequiredToPlay) {
            /*
             The asset invokes its completion handler on an arbitrary queue.
             To avoid multiple threads using our internal state at the same time
             we'll elect to use the main thread at all times, let's dispatch
             our handler to the main queue.
             */
            DispatchQueue.main.async {
                /*
                 `self.asset` has already changed! No point continuing because
                 another `newAsset` will come along in a moment.
                 */
                guard newAsset == self.asset else { return }
                
                /*
                 Test whether the values of each of the keys we need have been
                 successfully loaded.
                 */
                for key in AudioFilePlayer.assetKeysRequiredToPlay {
                    var error: NSError?
                    
                    if newAsset.statusOfValue(forKey: key, error: &error) == .failed {
                        let stringFormat = NSLocalizedString("error.asset_key_%@_failed.description", comment: "Can't use this AVAsset because one of it's keys failed to load")
                        
                        let message = String.localizedStringWithFormat(stringFormat, key)
                        print(message)
                        // self.handleErrorWithMessage(message, error: error)
                        
                        return
                    }
                }
                if !newAsset.isPlayable || newAsset.hasProtectedContent {
                    let message = NSLocalizedString("error.asset_not_playable.description", comment: "Can't use this AVAsset because it isn't playable or has protected content")
                    print(message)
                    return
                }
                self.playerItem = AVPlayerItem(asset: newAsset)
            }
        }
    }
    
    func playerItemDidReachEnd(notification: NSNotification) {
        player.seek(to: kCMTimeZero)
        player.pause()
        state = .stopped
        delegate?.trackFinishedPlaying()
    }
}
