//
//  AudioPlayerControlsView.swift
//  PodCatcher
//
//  Created by Christopher Webb on 5/13/18.
//  Copyright © 2018 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

final class AudioPlayerControlsView: UIView, BaseView {
    
    weak var delegate: AudioPlayerControlsViewDelegate?
    
    var currentPodcast: Episodes?  {
        didSet {
            configureFields()
        }
    }
    
    var currentState: AudioState = .stopped {
        didSet {
            switch currentState {
            case .playing:
                DispatchQueue.main.async {
                    self.playButton.isHidden = true
                    self.playButton.alpha = 0
                    self.pauseButton.isHidden = false
                    self.pauseButton.alpha = 1
                }
            case .paused:
                DispatchQueue.main.async {
                    self.pauseButton.isHidden = true
                    self.pauseButton.alpha = 0
                }
            case .stopped:
                DispatchQueue.main.async {
                    self.pauseButton.isHidden = true
                    self.pauseButton.alpha = 0
                    self.episodeTitle.text = "Not Playling"
                }
            }
        }
    }
    
    @IBOutlet weak var timeLeftLabel: UILabel!
    @IBOutlet weak var timePlayedLabel: UILabel!
    @IBOutlet weak var playtimeSlider: UISlider!
    @IBOutlet weak var episodeTitle: UILabel!
    @IBOutlet weak var podcastArtist: UILabel!
    @IBOutlet weak var podcastDuration: UILabel!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = UIColor(red:0.97, green:0.97, blue:0.97, alpha:1.0)
    }
    
    func setup() {
        configureFields()
        episodeTitle.textAlignment = .center
        podcastArtist.textAlignment = .center
        playtimeSlider.addTarget(self, action: #selector(changeSliderValue(value:)), for: .valueChanged)
        episodeTitle.numberOfLines = 0
        setupButtons()
        configure()
    }
    
    func setupButtons() {
        playButton.setImage(#imageLiteral(resourceName: "play").withRenderingMode(.alwaysTemplate), for: .normal)
        pauseButton.setImage(#imageLiteral(resourceName: "pause-round").withRenderingMode(.alwaysTemplate), for: .normal)
        skipButton.setImage(#imageLiteral(resourceName: "fastfw").withRenderingMode(.alwaysTemplate), for: .normal)
        backButton.setImage(#imageLiteral(resourceName: "rewind2").withRenderingMode(.alwaysTemplate), for:  .normal)
        playButton.addTarget(self, action: #selector(playButton(tapped:)), for: .touchUpInside)
        pauseButton.addTarget(self, action: #selector(pauseButton(tapped:)), for: .touchUpInside)
        skipButton.addTarget(self, action: #selector(skipButton(tapped:)), for: .touchUpInside)
        backButton.tintColor = .black
        playButton.tintColor = .black
        pauseButton.tintColor = .black
        skipButton.tintColor = .black
        playtimeSlider.isUserInteractionEnabled = true
    }
    
    func configure() {
        configure(playtimeSlider: playtimeSlider)
        configure(episodeTitle: episodeTitle)
        configure(podcastArtist: podcastArtist)
        configure(podcastDuration: podcastDuration)
        configure(controlButton: playButton)
        configure(controlButton: pauseButton)
        configure(skipButton: skipButton)
        configure(backButton: backButton)
        configure(timeLeftLabel: timeLeftLabel)
        configure(timePlayedLabel: timePlayedLabel)
        playtimeSlider.isUserInteractionEnabled = true
        bringSubview(toFront: playtimeSlider)
    }
    
    func configure(playtimeSlider: UISlider) {
        playtimeSlider.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            playtimeSlider.widthAnchor.constraint(equalTo: widthAnchor),
            playtimeSlider.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.1),
            playtimeSlider.centerXAnchor.constraint(equalTo: centerXAnchor)
            ])
        playtimeSlider.isUserInteractionEnabled = true
        
        if UIDevice().userInterfaceIdiom == .phone {
            
            switch UIScreen.main.nativeBounds.height {
                
            case 480, 960, 1136:
                NSLayoutConstraint.activate([
                    playtimeSlider.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.1),
                    playtimeSlider.centerXAnchor.constraint(equalTo: centerXAnchor),
                    playtimeSlider.topAnchor.constraint(equalTo: topAnchor, constant: -35)
                    ])
            case 1334:
                NSLayoutConstraint.activate([
                    playtimeSlider.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.1),
                    playtimeSlider.centerXAnchor.constraint(equalTo: centerXAnchor),
                    playtimeSlider.topAnchor.constraint(equalTo: topAnchor, constant: -60)
                    ])
            case 2208:
                NSLayoutConstraint.activate([
                    playtimeSlider.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.1),
                    playtimeSlider.topAnchor.constraint(equalTo: topAnchor, constant: -30)
                    ])
            default:
                print("default")
            }
        }
    }
    
    func configure(episodeTitle: UILabel) {
        add(episodeTitle)
        episodeTitle.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            episodeTitle.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.9),
            episodeTitle.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.1),
            episodeTitle.centerXAnchor.constraint(equalTo: centerXAnchor),
            episodeTitle.topAnchor.constraint(equalTo: playtimeSlider.bottomAnchor, constant: 15)
            ])
    }
    
    func configure(podcastArtist: UILabel) {
        add(podcastArtist)
        podcastArtist.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            podcastArtist.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.9),
            podcastArtist.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.08),
            podcastArtist.centerXAnchor.constraint(equalTo: centerXAnchor),
            podcastArtist.topAnchor.constraint(equalTo: episodeTitle.bottomAnchor, constant: 10)
            ])
    }
    
    func configure(podcastDuration: UILabel) {
        add(podcastDuration)
        podcastDuration.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            podcastDuration.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.9),
            podcastDuration.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.08),
            podcastDuration.centerXAnchor.constraint(equalTo: centerXAnchor),
            podcastDuration.topAnchor.constraint(equalTo: podcastArtist.bottomAnchor, constant: 15)
            ])
    }
    
    func configure(timeLeftLabel: UILabel) {
        add(timeLeftLabel)
        timeLeftLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            timeLeftLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.3),
            timeLeftLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.05),
            timeLeftLabel.rightAnchor.constraint(equalTo: skipButton.rightAnchor, constant: 25),
            timeLeftLabel.bottomAnchor.constraint(equalTo: playtimeSlider.topAnchor, constant: -10)
            ])
    }
    
    func configure(timePlayedLabel: UILabel) {
        add(timePlayedLabel)
        timePlayedLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            timePlayedLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.3),
            timePlayedLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.05),
            timePlayedLabel.leftAnchor.constraint(equalTo: backButton.leftAnchor, constant: -25),
            timePlayedLabel.bottomAnchor.constraint(equalTo: playtimeSlider.topAnchor, constant: -10)
            ])
    }
    
    func configure(backButton: UIButton) {
        add(backButton)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 60).isActive = true
        backButton.topAnchor.constraint(equalTo: playButton.topAnchor).isActive = true
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 480, 960, 1136:
                print("1136")
            case 1334, 2208:
                backButton.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 0.14).isActive = true
                backButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.14).isActive = true
            default:
                break
            }
        }
    }
    
    func configure(skipButton: UIButton) {
        add(skipButton)
        skipButton.translatesAutoresizingMaskIntoConstraints = false
        skipButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -60).isActive = true
        skipButton.topAnchor.constraint(equalTo: playButton.topAnchor).isActive = true
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 480, 960, 1136:
                break
            case 1334, 2208:
                skipButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.14).isActive = true
                skipButton.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 0.14).isActive = true
            default:
                break
            }
        }
    }
    
    func configure(controlButton: UIButton) {
        add(controlButton)
        controlButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            controlButton.centerXAnchor.constraint(equalTo: centerXAnchor)
            ])
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 480, 960:
                NSLayoutConstraint.activate([
                    controlButton.topAnchor.constraint(equalTo: podcastArtist.bottomAnchor, constant: 30),
                    controlButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.07),
                    controlButton.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.3)
                    ])
            case 1136:
                NSLayoutConstraint.activate([
                    controlButton.topAnchor.constraint(equalTo: podcastArtist.bottomAnchor, constant: 30),
                    controlButton.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.40),
                    controlButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.04)
                    ])
            case 1334:
                NSLayoutConstraint.activate([
                    controlButton.topAnchor.constraint(equalTo: podcastArtist.bottomAnchor, constant: 40),
                    controlButton.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.14),
                    controlButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.14)
                    ])
            case 2208:
                NSLayoutConstraint.activate([
                    controlButton.topAnchor.constraint(equalTo: podcastArtist.bottomAnchor, constant: 46),
                    controlButton.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 0.14),
                    controlButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.14)
                    ])
            default:
                break
            }
        }
    }
    
    @objc func playButton(tapped: Bool) {
       
        currentState = .playing
        delegate?.playButton(tapped: tapped)
    }
    
    @objc func pauseButton(tapped: Bool) {
      
        currentState = .paused
        playButton.isHidden = false
        playButton.alpha = 1
        pauseButton.isHidden = true
        pauseButton.alpha = 0
        delegate?.pauseButton(tapped: tapped)
    }
    
    @objc func skipButton(tapped: Bool) {
        delegate?.skipButton(tapped: tapped)
    }
    
    func backButton(tapped: Bool) {
        delegate?.backButton(tapped: tapped)
    }
    
    func configureFields() {
        guard episodeTitle != nil else { return }
        DispatchQueue.main.async {
            self.episodeTitle.text = self.currentPodcast?.title
            self.podcastArtist.text =  self.currentPodcast!.podcastTitle
            self.podcastDuration.text  = ""
        }
    }
    
    @IBAction func sliderValueChanged(_ sender: Any) {
        print(playtimeSlider.value)
        delegate?.sliderValue(set: Double(playtimeSlider.value))
    }
    
    @objc func changeSliderValue(value: Float) {
        delegate?.sliderValue(set: Double(playtimeSlider.value))
    }
    
    @IBAction func dismiss(_ sender: Any) {
        delegate?.dismiss(tapped: true)
    }
}
