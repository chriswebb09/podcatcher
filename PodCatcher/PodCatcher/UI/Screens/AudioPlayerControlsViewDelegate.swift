//
//  AudioPlayerControlsViewDelegate.swift
//  PodCatcher
//
//  Created by Christopher Webb on 5/13/18.
//  Copyright © 2018 Christopher Webb-Orenstein. All rights reserved.
//

import Foundation

protocol AudioPlayerControlsViewDelegate: class {
    func playButton(tapped: Bool)
    func pauseButton(tapped: Bool)
    func skipButton(tapped: Bool)
    func backButton(tapped: Bool)
    func dismiss(tapped: Bool)
    func sliderValue(set: Double)
}
