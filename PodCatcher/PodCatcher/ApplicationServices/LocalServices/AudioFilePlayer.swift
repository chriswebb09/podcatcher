import Foundation
import AVFoundation

enum PlayerState {
    case playing, paused, stopped
}

var audioCache = NSCache<NSString, AVAsset>()

protocol AudioFile {
    var audioUrlSting: String { get set }
}

final class AudioFilePlayer: NSObject {
    
    var url: URL
    
    var state: PlayerState = .stopped
    
    weak var delegate: AudioFilePlayerDelegate?
    
    lazy var asset: AVURLAsset? = {
        var asset: AVURLAsset = AVURLAsset(url: self.url)
        asset.resourceLoader.setDelegate(self, queue: DispatchQueue.main)
        return asset
    }()
    
    lazy var player: AVPlayer = {
        var player: AVPlayer = AVPlayer(playerItem: self.playerItem)
        player.actionAtItemEnd = AVPlayerActionAtItemEnd.none
        return player
    }()
    
    lazy var playerItem: AVPlayerItem = {
        var playerItem: AVPlayerItem = AVPlayerItem(asset: self.asset!)
        return playerItem
    }()
    
    var currentTime: Double {
        
        get {
            return CMTimeGetSeconds(player.currentTime())
        }
        
        set {
            let newTime = CMTimeMakeWithSeconds(newValue, 1000)
            player.seek(to: newTime, toleranceBefore: kCMTimeZero, toleranceAfter: kCMTimeZero)
        }
    }
    
    var duration: Double {
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
    
    init(url: URL) {
        self.url = url
        super.init()
        guard let asset = asset else { return }
        getTrackDuration(asset: asset)
    }
    
    convenience override init() {
        self.init()
        guard let url = URL(string: "test") else { return }
        self.url = url
    }
}

extension AudioFilePlayer: Playable {
    
    func play() {
        state = .playing
        play(player: player)
    }
    
    func pause(){
        state = .paused
        player.pause()
    }
    
    func setUrl(from string: String?) {
        guard let urlString = string else { return }
        guard let url = URL(string: urlString) else { return }
        self.url = url
        guard let asset = asset else { return }
        getTrackDuration(asset: asset)
    }
    
    func setUrl(with url: URL) {
        self.url = url
        guard let asset = asset else { return }
        getTrackDuration(asset: asset)
    }
    
    func play(player: AVPlayer) {
        player.playImmediately(atRate: 1)
    }
    
    
    func removeObservers() {
        self.removePlayTimeObserver(timeObserver: timeObserver)
    }
}

extension AudioFilePlayer: AVAssetResourceLoaderDelegate {
    
    func getTrackDuration(asset: AVURLAsset) {
        asset.loadValuesAsynchronously(forKeys: ["tracks", "duration"]) {
            guard let asset = self.asset else { return }
            let audioDuration = asset.duration
            let audioDurationSeconds = CMTimeGetSeconds(audioDuration)
            let hours: Int = Int(audioDurationSeconds / 3600)
            let minutes = Int(audioDurationSeconds.truncatingRemainder(dividingBy: 3600) / 60)
            let rem = Int(audioDurationSeconds.truncatingRemainder(dividingBy: 60))
            
            var formattedSeconds = ""
            if rem < 10 {
                formattedSeconds = "0\(rem)"
            } else {
                formattedSeconds = "\(rem)"
            }
            
            var formattedMinutes = ""
            if minutes < 10 {
                formattedMinutes = "0\(minutes)"
            } else {
                formattedMinutes = "\(minutes)"
            }
            
            var formattedTime = ""
            if hours > 0 {
                formattedTime = "\(hours):\(formattedMinutes):\(formattedSeconds)"
            } else {
                 formattedTime = "\(formattedMinutes):\(formattedSeconds)"
            }
            
            self.delegate?.trackDurationCalculated(stringTime: formattedTime, timeValue: audioDurationSeconds)
        }
    }

    func observePlayTime() {
        if self.delegate == nil {
            print("Delegate is not set")
            return
        }
        timeObserver = player.addPeriodicTimeObserver(forInterval: CMTimeMake(1, 30), queue: .main) { time in
            guard let currentItem = self.player.currentItem else { return }
            let fraction = CMTimeGetSeconds(time) / CMTimeGetSeconds(currentItem.duration)
            let time = fraction / 450
            self.delegate?.updateProgress(progress: time)
        }
    }
    
    func playerItemDidReachEnd(notification: NSNotification) {
        state = .stopped
        delegate?.trackFinishedPlaying()
        player.seek(to: kCMTimeZero)
        player.pause()
    }
    
    func removePlayTimeObserver(timeObserver: Any?) {
        guard let test = timeObserver else { return }
        player.removeTimeObserver(test)
    }
    
    func resourceLoader(_ resourceLoader: AVAssetResourceLoader, shouldWaitForLoadingOfRequestedResource loadingRequest: AVAssetResourceLoadingRequest) -> Bool {
        if loadingRequest.request.url == url {
            print("loading...")
            return true
        }
        return false
    }
}
