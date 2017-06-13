//
//  Playable.swift
//  PodCatcher
//
//  Created by Christopher Webb-Orenstein on 6/12/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import AVFoundation

protocol Playable {
    var url: URL { get set }
    var currentTime: Double  { get set }
    weak var delegate: AudioFilePlayerDelegate? { get set }
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
