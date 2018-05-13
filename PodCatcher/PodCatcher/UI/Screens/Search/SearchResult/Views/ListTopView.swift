//
//  ListTopView.swift
//  PodCatcher
//
//  Created by Christopher Webb-Orenstein on 3/11/18.
//  Copyright © 2018 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

extension UIView {
    func fadeIn(_ duration: TimeInterval = 0.1, delay: TimeInterval = 0.0, completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.alpha = 1.0
        }, completion: completion)  }
    
    func fadeOut(_ duration: TimeInterval = 0.1, delay: TimeInterval = 0.0, completion: @escaping (Bool) -> Void = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.alpha = 0.0
        }, completion: completion)
    }
}

extension UIImageView {
    
    func performUIUpdate(using closure: @escaping () -> Void) {
        // If we are already on the main thread, execute the closure directly
        if Thread.isMainThread {
            closure()
        } else {
            DispatchQueue.main.async(execute: closure)
        }
    }
    
    func addBlurEffect() {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(blurEffectView)
    }
    
    func downloadImage(url: URL) {
        self.image = nil
        let urlconfig = URLSessionConfiguration.ephemeral
        urlconfig.timeoutIntervalForRequest = 8
        let session = URLSession(configuration: urlconfig, delegate: nil, delegateQueue: nil)
        let request = URLRequest(url: url,  cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 8)
        session.dataTask(with: request) { data, response, error in
            if error != nil {
                print(error?.localizedDescription ?? "Unknown error")
                return
            }
            self.performUIUpdate {
                self.image = nil
            }
            
            if let data = data, let image = UIImage(data: data) {
                
                self.performUIUpdate {
                    self.image = image
                }
            }}.resume()
    }
    
    func dropShadow() {
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOpacity = 0.25
        self.layer.shadowOffset = CGSize(width: -0.9, height: 0.8)
        self.layer.shadowRadius = 0.6
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }
}

import UIKit

final class PodcastListTopView: UIView, BaseView {
    
    var backgroundImage: UIImageView! = {
        var podcastImageView = UIImageView()
        return podcastImageView
    }()
    
    let concurrentPhotoQueue = DispatchQueue( label: "com.Queue", attributes: .concurrent)
    
    // MARK: - UI Properties
    
    private var podcastImageView: UIImageView! = {
        var podcastImageView = UIImageView()
        podcastImageView.layer.cornerRadius = 3
        podcastImageView.layer.borderWidth = 1
        podcastImageView.layer.borderColor = UIColor.lightGray.cgColor
        return podcastImageView
    }()
    
    var blurView: UIVisualEffectView!
    
    let background: UIImageView? = UIImageView()
    
    func setTopImage(from url: URL) {
        DispatchQueue.main.async {
            print("url")
            self.podcastImageView.downloadImage(url: url)
            self.backgroundImage.image = self.podcastImageView.image
            self.backgroundImage.downloadImage(url: url)
        }
    }
    
//    func setTopImage(image: UIImage) {
//        print("image")
//        self.podcastImageView.image = image
//        self.backgroundImage.image = podcastImageView.image
//    }
    
    func getImageView() -> UIImageView {
        return podcastImageView
    }
    
    func removeLayer() {
        print("REMVOE")
        layer.sublayers = nil
    }
    
    func setupBackground() {
        //alpha = 0
        DispatchQueue.main.async { [weak self] in
            if let strongSelf = self {
                strongSelf.backgroundImage.image = strongSelf.podcastImageView.image
                strongSelf.backgroundImage.addBlurEffect()
                guard let imageView = strongSelf.podcastImageView else { return }
              //  strongSelf.fadeIn()
                strongSelf.bringSubview(toFront: imageView)
                strongSelf.background?.alpha = 0.6
            }
        }
        DispatchQueue.main.async {
            self.podcastImageView.dropShadow()
        }
    }
    
    func setup() {
       // self.alpha = 0
        setup(podcastImageView: podcastImageView)
        setup(backgroundImageView: backgroundImage)
        setupBackground()
    }
    
    func setup(backgroundImageView: UIImageView) {
        addSubview(backgroundImageView)
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            backgroundImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 1),
            backgroundImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1),
            backgroundImageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -10),
            backgroundImageView.centerXAnchor.constraint(equalTo: centerXAnchor)
            ])
    }
    
    func setup(podcastImageView: UIImageView) {
        addSubview(podcastImageView)
        podcastImageView.translatesAutoresizingMaskIntoConstraints = false
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 480, 960, 1136:
                NSLayoutConstraint.activate([
                    podcastImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.9),
                    podcastImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5),
                    podcastImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
                    podcastImageView.centerXAnchor.constraint(equalTo: centerXAnchor)
                    ])
            case 1334:
                NSLayoutConstraint.activate([
                    podcastImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.9),
                    podcastImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5),
                    podcastImageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -5),
                    podcastImageView.centerXAnchor.constraint(equalTo: centerXAnchor)
                    ])
            case 2208:
                NSLayoutConstraint.activate([
                    podcastImageView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 0.6),
                    podcastImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.6),
                    podcastImageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -10),
                    podcastImageView.centerXAnchor.constraint(equalTo: centerXAnchor)
                    ])
            case 2436:
                NSLayoutConstraint.activate([
                    podcastImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.9),
                    podcastImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5),
                    podcastImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
                    podcastImageView.centerXAnchor.constraint(equalTo: centerXAnchor)
                    ])
            default:
                break
            }
        }
        
        podcastImageView.layoutIfNeeded()
        layoutIfNeeded()
    }
    
    func configureTopImage() {
        podcastImageView.dropShadow()
    }
    
    func setupTop() {
        backgroundColor = .clear
        self.alpha = 0
        setup()
        layer.setCellShadow(contentView: self)
        autoresizingMask = [.flexibleWidth, .flexibleHeight]
        DispatchQueue.main.async {
            self.fadeIn()
        }
    }
}

