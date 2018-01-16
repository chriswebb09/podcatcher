//
//  StateView.swift
//  PodCatcher
//
//  Created by Christopher Webb-Orenstein on 1/12/18.
//  Copyright © 2018 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

protocol StateView {
    var stateData: String { get set }
    var stateImage: UIImage { get set }
    var informationLabel: UILabel { get }
    var iconView: UIImageView { get }
}
