//
//  TagsViewController.swift
//  PodCatcher
//
//  Created by Christopher Webb-Orenstein on 1/15/18.
//  Copyright © 2018 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit
import CoreData

// https://www.objc.io/blog/2018/01/09/justified-flow-layout/

class TagsViewController: UIViewController {
    
    var buttonView: ButtonsView!
    
    var constraint: NSLayoutConstraint!
    
    var topPodcasts: [TopPodcast] = []
    
    var tags: [String] = ["Society & Culture", "Business", "Politics", "Performing Arts", "Law", "Health", "Medicine", "News", "Education", "Personal Journals", "Mystery", "History", "News & Politics", "Comedy", "True Crime", "Philosophy", "Science", "Paranormal", "Religion", "Spirituality", "Russian History",  "Geopolitics"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        buttonView = ButtonsView()
        
        let buttons = (0..<tags.count).map { UIButton(pill: "\(tags[$0])") }
        for b in buttons { buttonView.addSubview(b) }
        view.add(buttonView)
        
        buttonView.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 11.0, *) {
            buttonView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10).isActive = true
            constraint = buttonView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10)
            buttonView.topAnchor.constraint(equalTo: view.topAnchor, constant: 10).isActive = true
        } else {
            constraint = buttonView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        }
        constraint.isActive = true
    }
}
