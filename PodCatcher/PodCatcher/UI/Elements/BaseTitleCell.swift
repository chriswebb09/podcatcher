//
//  BaseTitleCell.swift
//  PodCatcher
//
//  Created by Christopher Webb on 5/12/18.
//  Copyright © 2018 Christopher Webb-Orenstein. All rights reserved.
//

import Foundation
import UIKit

protocol BaseTitleCell {
    func configure(with title: String)
    func setup()
    func setup(titleLabel: UILabel)
}
