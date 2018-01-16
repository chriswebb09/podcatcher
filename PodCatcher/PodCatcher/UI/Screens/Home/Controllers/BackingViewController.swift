//
//  BackingViewController.swift
//  PodCatcher
//
//  Created by Christopher Webb-Orenstein on 1/15/18.
//  Copyright © 2018 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

final class BackingViewController: UIViewController {
    
    // MARK: - Properties
    
    let sliderBarView = UIView()
    
    var sliderControl = SliderControl()
    
    var backingView: UIView = UIView()
    
    var homeViewController: HomeViewController!
    
    var downloadedViewController: DownloadedViewController = DownloadedViewController()
    
    var tagsViewController: TagsViewController = TagsViewController()
    
    var currentEmbeddedVC: UIViewController {
        didSet {
            removeChild(controller: oldValue)
            embedChild(controller: currentEmbeddedVC, in: backingView)
        }
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.currentEmbeddedVC = UIViewController()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        edgesForExtendedLayout = []
        DispatchQueue.main.async {
            self.view.add(self.backingView)
            self.view.add(self.sliderControl)
            let titles = ["Subscribed", "Downloaded", "Tags"]
            self.sliderControl.translatesAutoresizingMaskIntoConstraints = false
            self.sliderControl.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
            self.sliderControl.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1).isActive = true
            self.sliderControl.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.07).isActive = true
            self.sliderControl.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
            self.sliderBarView.layoutIfNeeded()
            self.sliderControl.layoutIfNeeded()
            self.sliderControl.isUserInteractionEnabled = true
            self.sliderControl.setSegmentItems(titles)
            self.sliderControl.delegate = self
            self.backingView.translatesAutoresizingMaskIntoConstraints = false
            self.backingView.topAnchor.constraint(equalTo: self.sliderControl.bottomAnchor, constant: 0).isActive = true
            self.backingView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
            self.backingView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1).isActive = true
            self.backingView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
            self.backingView.layoutIfNeeded()
            self.currentEmbeddedVC = self.homeViewController
        }
    }
}

extension BackingViewController: SliderControlDelegate {
    
    func didSelect(_ segmentIndex: Int) {
        switch segmentIndex {
        case 0:
            currentEmbeddedVC = homeViewController
        case 1:
            currentEmbeddedVC = downloadedViewController
        case 2:
            currentEmbeddedVC = tagsViewController
        default:
            currentEmbeddedVC = homeViewController
        }
    }
}
