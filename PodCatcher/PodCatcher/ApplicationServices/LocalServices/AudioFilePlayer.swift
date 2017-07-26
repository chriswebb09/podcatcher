import Foundation
import AVFoundation

enum PlayerState {
    case playing, paused, stopped
}

var audioCache = NSCache<NSString, AVAsset>()

protocol AudioFilePlayerDelegate: class {
    func updateProgress(progress: Double)
    func trackDurationCalculated(stringTime: String, timeValue: Float64)
    func trackFinishedPlaying()
}

protocol AudioFile {
    var audioUrlSting: String { get set }
}

final class AudioFilePlayer: NSObject {
    
    var url: URL!
    
    static let shared = AudioFilePlayer()
    
    var state: PlayerState = .stopped
    
    weak var delegate: AudioFilePlayerDelegate?
    
    var player: AVPlayer
    
    var playerItem: AVPlayerItem!
    
    var currentTime: Double {
        get {
            return CMTimeGetSeconds(player.currentTime())
        }
        set {
            let newTime = CMTimeMakeWithSeconds(newValue, 1000)
            player.seek(to: newTime, toleranceBefore: kCMTimeZero, toleranceAfter: kCMTimeZero)
        }
    }
    
    var duration: Double? {
        guard let currentItem = player.currentItem else { return 0.0 }
        return CMTimeGetSeconds(currentItem.duration)
    }
    
    var timeObserver: Any?
    
    deinit {
        if let timeObserverToken = timeObserver {
            player.removeTimeObserver(timeObserverToken)
            self.timeObserver = nil
        }
    }
    
    override init() {
        self.player = AVPlayer()
        super.init()
    }
}

extension AudioFilePlayer {
    
    func play() {
        state = .playing
        player.playImmediately(atRate: 1)
    }
    
    func pause() {
        state = .paused
      //  player.pause()
        player.playImmediately(atRate: 0)
    }
    
    func setUrl(from string: String?) {
        guard let urlString = string else { return }
        guard let url = URL(string: urlString) else { return }
        self.url = url
    }
    
    func setUrl(with url: URL) {
        self.url = url
    }
    
    func removePeriodicTimeObserver() {
        guard let token = timeObserver else { return }
        player.removeTimeObserver(token)
        timeObserver = nil
    }
    
    func playNext(asset: AVURLAsset) {
        playerItem = AVPlayerItem(asset: asset)
        player.replaceCurrentItem(with: playerItem)
        getTrackDuration(asset: asset)
    }
}

extension AudioFilePlayer: AVAssetResourceLoaderDelegate {
    
    func getTrackDuration(asset: AVURLAsset?) {
        
        guard let asset = asset else { return }
        asset.loadValuesAsynchronously(forKeys: ["tracks", "duration"]) { [weak self] in

            let audioDuration = asset.duration
            let audioDurationSeconds = CMTimeGetSeconds(audioDuration)
            let hours: Int = Int(audioDurationSeconds / 3600)
            let minutes = Int(audioDurationSeconds.truncatingRemainder(dividingBy: 3600) / 60)
            let rem = Int(audioDurationSeconds.truncatingRemainder(dividingBy: 60))
            guard let strongSelf = self else { return }
            let formattedSeconds = strongSelf.formatString(time: rem)
            let formattedMinutes = strongSelf.formatString(time: minutes)
            
            var formattedTime = ""
            if hours > 0 {
                formattedTime = "\(hours):\(formattedMinutes):\(formattedSeconds)"
            } else {
                formattedTime = "\(formattedMinutes):\(formattedSeconds)"
            }
            
            strongSelf.delegate?.trackDurationCalculated(stringTime: formattedTime, timeValue: audioDurationSeconds)
        }
    }
    
    func formatString(time: Int) -> String {
        var formattedString = ""
        if time < 10 {
            formattedString = "0\(time)"
        } else {
            formattedString = "\(time)"
        }
        return formattedString
    }
    
    func observePlayTime() {
        let interval = CMTime(seconds: 0.5, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        let mainQueue = DispatchQueue.main
        timeObserver = player.addPeriodicTimeObserver(forInterval: interval, queue: mainQueue) { [weak self] time in
            guard let currentItem = self?.player.currentItem else { return }
            let fraction = CMTimeGetSeconds(time) / CMTimeGetSeconds(currentItem.duration)
            let time = fraction / 450
            self?.delegate?.updateProgress(progress: time)
        }
    }
    
    func playerItemDidReachEnd(notification: NSNotification) {
        state = .stopped
        delegate?.trackFinishedPlaying()
        player.seek(to: kCMTimeZero)
        player.pause()
    }
}

