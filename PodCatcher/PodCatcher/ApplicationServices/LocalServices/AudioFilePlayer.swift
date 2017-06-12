//
//  AudioFilePlayer.swift
//  PodCatcher
//
//  Created by Christopher Webb-Orenstein on 6/11/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import Foundation
import AVFoundation
import MediaPlayer

protocol TrackPlayerDelegate: class {
    func updateProgress(progress: Double)
    func trackDurationCalculated(stringTime: String, timeValue: Float64)
    func trackFinishedPlaying()
}

protocol Playable {
    var url: URL { get set }
    var currentTime: Double  { get set }
    weak var delegate: TrackPlayerDelegate? { get set }
    var timeObserver: Any? { get set }
    var player: AVPlayer { get set }
    func play()
    func setUrl(with url: URL)
    func setUrl(from string: String?)
    func getTrackDuration(asset: AVURLAsset)
    func observePlayTime()
    func playerItemDidReachEnd(notification: NSNotification)
    func removePlayTimeObserver(timeObserver: Any?)
}

let audioCache = NSCache<NSString, AVURLAsset>()

final class AudioFilePlayer: NSObject, AVAssetResourceLoaderDelegate, Playable {
    
    var url: URL
    
    weak var delegate: TrackPlayerDelegate?
    
    lazy var asset: AVURLAsset = {
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
        var playerItem: AVPlayerItem = AVPlayerItem(asset: self.asset)
        return playerItem
    }()
    
    var currentTime: Double {
        get {
            return CMTimeGetSeconds(player.currentTime())
        }
        
        set {
            let newTime = CMTimeMakeWithSeconds(newValue, 10)
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
        self.getTrackDuration(asset: self.asset)
    }
    
    convenience override init() {
        self.init()
        self.url = URL(string: "test")!
    }
    
    func play() {
        play(player: player)
    }
    
    func setUrl(from string: String?) {
        guard let urlString = string else { return }
        guard let url = URL(string: urlString) else { return }
        self.url = url
        getTrackDuration(asset: self.asset)
    }
    
    func setUrl(with url: URL) {
        self.url = url
        getTrackDuration(asset: self.asset)
    }
    
    func play(player: AVPlayer) {
        player.playImmediately(atRate: 1)
    }
    
    func getTrackDuration(asset: AVURLAsset) {
        asset.loadValuesAsynchronously(forKeys: ["tracks", "duration"]) {
            let audioDuration = self.asset.duration
            let audioDurationSeconds = CMTimeGetSeconds(audioDuration)
            let minutes = Int(audioDurationSeconds / 60)
            let rem = Int(audioDurationSeconds.truncatingRemainder(dividingBy: 60))
            self.delegate?.trackDurationCalculated(stringTime: "\(minutes):\(rem + 2)", timeValue: audioDurationSeconds)
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
        delegate?.trackFinishedPlaying()
        player.seek(to: kCMTimeZero)
        player.pause()
    }
    
    func removePlayTimeObserver(timeObserver: Any?) {
        guard let test = timeObserver else { return }
        player.removeTimeObserver(test)
    }
}
