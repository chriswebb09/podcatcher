//
//  CardPlayerViewController.swift
//  PodCatcher
//
//  Created by Christopher Webb on 5/13/18.
//  Copyright © 2018 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

class CardPlayerViewController: UIViewController, LowerModuleAnimatable, BottomSectionAnimatable, CoverImageAnimatable {
    
    var currentState: AudioState = .stopped
    
    var currentPodcast: Episodes?
    
    weak var delegate: CardPlayerViewControllerDelegate?
    
    var audioTimePlayed: Double = 0
    var audioTimeLeft: Double = 0
    var audioTimeDuration: Double = 0
    
    // MARK: - Properties
    
    weak var sourceView: CardPlayerSourceProtocol!
    
    var tabBarImage: UIImage?
    var backingImage: UIImage?
    let primaryDuration = 0.25
    var endBackingImage: UIImage?
    let cardCornerRadius: CGFloat = 5
    var backingImageEdgeInset: CGFloat = 15.0
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var stretchySkirt: UIView!
    @IBOutlet weak var dismissChevron: UIButton!
    @IBOutlet weak var coverImageContainer: UIView!
    @IBOutlet weak var coverArtImage: UIImageView!
    @IBOutlet weak var coverImageLeading: NSLayoutConstraint!
    @IBOutlet weak var coverImageTop: NSLayoutConstraint!
    @IBOutlet weak var coverImageBottom: NSLayoutConstraint!
    @IBOutlet weak var coverImageHeight: NSLayoutConstraint!
    @IBOutlet weak var coverImageContainerTopInset: NSLayoutConstraint!
    @IBOutlet weak var backingImageView: UIImageView!
    @IBOutlet weak var dimmerLayer: UIView!
    @IBOutlet weak var backingImageTopInset: NSLayoutConstraint!
    @IBOutlet weak var backingImageLeadingInset: NSLayoutConstraint!
    @IBOutlet weak var backingImageTrailingInset: NSLayoutConstraint!
    @IBOutlet weak var backingImageBottomInset: NSLayoutConstraint!
    @IBOutlet weak var lowerModuleTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomSectionHeight: NSLayoutConstraint!
    @IBOutlet weak var bottomSectionLowerConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomSectionImageView: UIImageView!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - View Life Cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        modalPresentationCapturesStatusBarAppearance = true //allow this VC to control the status bar appearance
        modalPresentationStyle = .overFullScreen //dont dismiss the presenting view controller when presented
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backingImageView.image = backingImage
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        } else { }
        coverImageContainer.layer.cornerRadius = cardCornerRadius
        if #available(iOS 11.0, *) {
            coverImageContainer.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        } else { }
        self.coverArtImage.dropShadow()
    }
    
    private func setShadow() {
        coverImageContainer.backgroundColor = UIColor(red:0.97, green:0.97, blue:0.97, alpha:1.0)
        DispatchQueue.main.async {
            self.coverArtImage.layer.shadowColor = UIColor.black.cgColor
            self.coverArtImage.layer.shadowOpacity = 0.5
            self.coverArtImage.layer.shadowOffset = CGSize(width: 10.0, height: 10.0)
            self.coverArtImage.layer.shadowRadius = 15
            self.coverArtImage.layer.shadowPath = UIBezierPath(rect: self.coverArtImage.bounds).cgPath
            self.coverArtImage.layer.shouldRasterize = true
            self.coverArtImage.layer.rasterizationScale = true ? UIScreen.main.scale : 1
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureImageLayerInStartPosition()
        coverArtImage.image = sourceView.originatingCoverImageView.image
        configureCoverImageInStartPosition()
        stretchySkirt.backgroundColor = UIColor(red:0.97, green:0.97, blue:0.97, alpha:1.0)
        configureLowerModuleInStartPosition()
        configureBottomSection()
        setShadow()
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            NotificationCenter.default.addObserver(self, selector: #selector(audioPlayerDidStartLoading(_:)), name: .audioPlayerDidStartLoading, object: appDelegate.audioPlayer)
            NotificationCenter.default.addObserver(self, selector: #selector(audioPlayerDidStartPlaying(_:)), name: .audioPlayerDidStartPlaying, object: appDelegate.audioPlayer)
            NotificationCenter.default.addObserver(self, selector: #selector(audioPlayerDidPause(_:)), name: .audioPlayerDidPause, object: appDelegate.audioPlayer)
            NotificationCenter.default.addObserver(self, selector: #selector(audioPlayerPlaybackTimeChanged(_:)), name: .audioPlayerPlaybackTimeChanged, object: appDelegate.audioPlayer)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateBackingImageIn()
        animateImageLayerIn()
        animateCoverImageIn()
        animateLowerModuleIn()
        animateBottomSectionOut()
        setShadow()
    }
    
    func audioPlayerWillStartPlaying(_ notification: Notification) {
        print(notification)
    }
    
    @objc private func audioPlayerDidStartLoading(_ notification: Notification) {
        print(notification)
    }
    
    @objc private func audioPlayerDidStartPlaying(_ notification: Notification) {
        print(notification)
    }
    
    @objc private func audioPlayerDidPause(_ notification: Notification) {
        print(notification)
    }
    
    @objc private func audioPlayerPlaybackTimeChanged(_ notification: Notification) {
        let secondsElapsed = notification.userInfo![AudioPlayerSecondsElapsedUserInfoKey]! as! Double
        print(secondsElapsed)
        let secondsRemaining = notification.userInfo![AudioPlayerSecondsRemainingUserInfoKey]! as! Double
        print(secondsRemaining)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("here")
        if let destination = segue.destination as? AudioPlayerControlViewController {
            destination.currentPodcast = currentPodcast
            destination.delegate = self
            destination.currentState = currentState
            destination.view.bringSubview(toFront: destination.audioPlayerControlsView)
            self.navigationController?.view.bringSubview(toFront: destination.audioPlayerControlsView)
            self.view.bringSubview(toFront: destination.audioPlayerControlsView)
        }
    }
    
    @IBAction func dismiss(_ sender: Any) {
        backingImage = endBackingImage
        animateBackingImageOut()
        animateCoverImageOut()
        animateImageLayerOut() { _ in
            self.dismiss(animated: false)
        }
        animateLowerModuleOut()
        animateBottomSectionIn()
    }
}

extension CardPlayerViewController: PodcastSubscriber, ImageLayerAnimatable {
    
    internal var startColor: UIColor {
        return UIColor.white.withAlphaComponent(0.3)
    }
    
    internal var endColor: UIColor {
        return .white
    }
    
    internal var imageLayerInsetForOutPosition: CGFloat {
        let imageFrame = view.convert(sourceView.originatingFrameInWindow, to: view)
        let inset = imageFrame.minY - backingImageEdgeInset
        return inset
    }
}

extension CardPlayerViewController: BackingImageAnimatable {
    
    internal var lowerModuleInsetForOutPosition: CGFloat {
        let bounds = view.bounds
        return bounds.height - bounds.width
    }
}

extension CardPlayerViewController: AudioPlayerControlViewControllerDelegate {
    
    func playButton(tapped: Bool) {
        delegate?.playButton(tapped: true)
    }
    
    func pauseButton(tapped: Bool) {
        delegate?.pauseButton(tapped: true)
    }
    
    func skipButton(tapped: Bool) {
        delegate?.skipButton(tapped: true)
    }
    
    func backButton(tapped: Bool) {
        delegate?.backButton(tapped: true)
    }
    
    func dismiss(tapped: Bool) {
        delegate?.dismiss(tapped: true)
    }
}
