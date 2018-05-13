//
//  MediaViewController.swift
//  PodCatcher
//
//  Created by Christopher Webb on 5/12/18.
//  Copyright © 2018 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

class MediaViewController: UIViewController {
    
    var topView = BrowseTopView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        edgesForExtendedLayout = []
        view.add(topView)
        topView.translatesAutoresizingMaskIntoConstraints = false
        topView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1).isActive = true
        topView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1).isActive = true
        topView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        topView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0).isActive = true
    }
}
