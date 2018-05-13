//
//  CardPlayerViewControllerDelegate.swift
//  PodCatcher
//
//  Created by Christopher Webb on 5/12/18.
//  Copyright © 2018 Christopher Webb-Orenstein. All rights reserved.
//

import Foundation

protocol CardPlayerViewControllerDelegate: class {
    func playButton(tapped: Bool)
    func pauseButton(tapped: Bool)
    func skipButton(tapped: Bool)
    func backButton(tapped: Bool)
    func dismiss(tapped: Bool)
}
