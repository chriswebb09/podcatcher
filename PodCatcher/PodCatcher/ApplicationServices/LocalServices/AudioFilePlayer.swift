import Foundation
import AVFoundation

enum PlayerState {
    case playing, paused, stopped
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
    
    func play() {
        player.playImmediately(atRate: 1)
        state = .playing
    }
    
    func pause() {
        player.playImmediately(atRate: 0)
        state = .paused
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
    
    func initPlayer(url: URL?)  {
        guard let url = url else { return }
        setUrl(with: url)
        self.url = url
        playNext(asset: AVURLAsset(url: url))
    }
}

extension AudioFilePlayer: AVAssetResourceLoaderDelegate {
    
    func getTrackDuration(asset: AVURLAsset?) {
        guard let asset = asset else { return }
        asset.loadValuesAsynchronously(forKeys: ["tracks", "duration"]) { [weak self] in
            let audioDuration = asset.duration
            let audioDurationSeconds = CMTimeGetSeconds(audioDuration)
            guard let strongSelf = self else { return }
            let formattedTime = String.constructTimeString(time: Double(audioDurationSeconds))
            strongSelf.delegate?.trackDurationCalculated(stringTime: formattedTime, timeValue: audioDurationSeconds)
        }
    }
    
    func observePlayTime() {
        let interval = CMTime(seconds: 0.5, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        let mainQueue = DispatchQueue.main
        timeObserver = player.addPeriodicTimeObserver(forInterval: interval, queue: mainQueue) { [weak self] time in
            guard let strongSelf = self else { return }
            guard let currentItem = strongSelf.player.currentItem else { return }
            let fraction = CMTimeGetSeconds(time) / CMTimeGetSeconds(currentItem.duration)
            let time = fraction / 450
            strongSelf.delegate?.updateProgress(progress: time)
        }
    }
    
    func playerItemDidReachEnd(notification: NSNotification) {
        player.seek(to: kCMTimeZero)
        player.pause()
        state = .stopped
        delegate?.trackFinishedPlaying()
    }
}
