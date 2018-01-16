//
//  PopAlert .swift
//  PodCatcher
//
//  Created by Christopher Webb-Orenstein on 1/12/18.
//  Copyright © 2018 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

protocol PopAlert {
    var containerView: UIView  { get }
    func showPopView(viewController: UIViewController)
    func hidePopView(viewController: UIViewController)
    func configureContainer()
}

