//
//  CardPlayerSourceProtocol.swift
//  PodCatcher
//
//  Created by Christopher Webb on 5/13/18.
//  Copyright © 2018 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

protocol CardPlayerSourceProtocol: class {
    var originatingFrameInWindow: CGRect { get }
    var originatingCoverImageView: UIImageView { get }
}
