//
//  MiniPlayerViewController.swift
//  PodCatcher
//
//  Created by Christopher Webb on 5/12/18.
//  Copyright © 2018 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

class MiniPlayerViewController: UIViewController, PodcastSubscriber {
    
    var currentPodcast: Episodes? {
        didSet {
            DispatchQueue.main.async {
                self.playButton.isEnabled = self.currentPodcast != nil
                self.pauseButton.isEnabled = self.currentPodcast != nil
            }
        }
    }
    
    // MARK: - Properties
    
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
    
    weak var delegate: MiniPlayerDelegate?
    
    // MARK: - IBOutlets
    
    var thumbImage: UIImageView! = UIImageView()
    var episodeTitle = UILabel()
    var playButton: UIButton! = UIButton()
    var pauseButton: UIButton! = UIButton()
    
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playButton.isEnabled = currentPodcast != nil
        currentState = .stopped
        configure()
        thumbImage.image = #imageLiteral(resourceName: "placeholder")
        
        DispatchQueue.main.async {
            self.thumbImage.layer.cornerRadius = 10
            self.view.backgroundColor = UIColor(red:0.94, green:0.94, blue:0.94, alpha:1.0)
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapGesture(_:)))
        view.addGestureRecognizer(tap)
        
        episodeTitle.font = Style.Font.MiniPlayer.title
        playButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
        pauseButton.setImage(#imageLiteral(resourceName: "pause-round"), for: .normal)
        playButton.addTarget(self, action: #selector(audio), for: .touchUpInside)
        pauseButton.addTarget(self, action: #selector(pause), for: .touchUpInside)
        episodeTitle.numberOfLines = 0
        
        episodeTitle.addGestureRecognizer(tap)
        thumbImage.addGestureRecognizer(tap)
    }
    
    @objc func audio() {
        currentState = .playing
        DispatchQueue.main.async {
            self.playButton.isHidden = true
            self.playButton.alpha = 0
            self.pauseButton.isHidden = false
            self.pauseButton.alpha = 1
        }
        delegate?.playButton(tapped: true)
    }
    
    func playUI() {
        currentState = .playing
        DispatchQueue.main.async {
            self.playButton.isHidden = true
            self.playButton.alpha = 0
            self.pauseButton.isHidden = false
            self.pauseButton.alpha = 1
        }
    }
    
    @objc func pause() {
        currentState = .paused
        playButton.isHidden = false
        playButton.alpha = 1
        pauseButton.isHidden = true
        pauseButton.alpha = 0
        delegate?.pauseButton(tapped: true)
    }
    
    func pauseUI() {
        currentState = .paused
        playButton.isHidden = false
        playButton.alpha = 1
        pauseButton.isHidden = true
        pauseButton.alpha = 0
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let podcast = currentPodcast else { return }
        delegate?.expandPodcast(episode: podcast)
    }
    
    func configure() {
        view.addSubview(thumbImage)
        thumbImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            thumbImage.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.16),
            thumbImage.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.8),
            thumbImage.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
            thumbImage.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])
        
        episodeTitle.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(episodeTitle)
        NSLayoutConstraint.activate([
            episodeTitle.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6),
            episodeTitle.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.8),
            episodeTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 20),
            episodeTitle.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])
        
        view.addSubview(playButton)
        playButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            playButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])
        
        view.addSubview(pauseButton)
        pauseButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pauseButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])
        
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 480, 960:
                NSLayoutConstraint.activate([
                    playButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.37),
                    playButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.07),
                    playButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -40),
                    pauseButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.07),
                    pauseButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.37),
                    pauseButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -40)
                    ])
            case 1136:
                NSLayoutConstraint.activate([
                    pauseButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -40),
                    pauseButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.40),
                    pauseButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.04),
                    playButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -40),
                    playButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.04),
                    playButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.40)
                    ])
            case 1334:
                NSLayoutConstraint.activate([
                    pauseButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.49),
                    pauseButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.1),
                    pauseButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
                    playButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.49),
                    playButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.1),
                    playButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20)
                    ])
            case 2208:
                NSLayoutConstraint.activate([
                    pauseButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5),
                    pauseButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.09),
                    pauseButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
                    playButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5),
                    playButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.09),
                    playButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20)
                    ])
            default:
                break
            }
        }
        DispatchQueue.main.async {
            self.thumbImage.layer.cornerRadius = 20
            self.view.backgroundColor = UIColor(red:0.94, green:0.94, blue:0.94, alpha:1.0)
        }
    }
    
    func playFor(episode: Episodes?) {
        configure(episode: episode)
        currentState = .playing
        delegate?.playButton(tapped: true)
    }
}

// MARK: - Internal

extension MiniPlayerViewController {
    
    func configure(episode: Episodes?) {
        episodeTitle.text = episode!.title
        currentPodcast = episode
        if let url = URL(string: episode!.podcastArtUrlString) {
            DispatchQueue.main.async {
                
                URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                    if error != nil {
                        print(error!)
                        return
                    }
                    
                    DispatchQueue.main.async {
                        self.thumbImage.image = UIImage(data: data!)
                        self.episodeTitle.text = episode!.title
                    }
                }).resume()
            }
        }
    }
}

// MARK: - IBActions

extension MiniPlayerViewController {
    
    @objc func tapGesture(_ sender: Any) {
        guard let podcast = currentPodcast else { return }
        delegate?.expandPodcast(episode: podcast)
    }
}

extension MiniPlayerViewController: CardPlayerSourceProtocol {
    
    var originatingFrameInWindow: CGRect {
        return view.convert(view.frame, to: nil)
    }
    
    var originatingCoverImageView: UIImageView {
        return thumbImage
    }
}
