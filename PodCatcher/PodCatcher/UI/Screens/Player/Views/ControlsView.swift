import UIKit

final class ControlsView: UIView {
    
    private var playtimeSliderView: UIView = {
        let playtimeSliderView = UIView()
        return playtimeSliderView
    }()
    
    var playtimeSlider: UISlider = {
        let slider = UISlider()
        slider.thumbTintColor = .white
        slider.maximumTrackTintColor = UIColor(red:1.00, green:0.71, blue:0.71, alpha:1.0)
        let thumbImage = #imageLiteral(resourceName: "line-gray").scaleToSize(CGSize(width: 2, height: 20))
        slider.setThumbImage(thumbImage, for: .normal)
        slider.setThumbImage(thumbImage, for: .selected)
        slider.minimumValue = 0
        slider.maximumValue = 100
        slider.tintColor = .white
        slider.isUserInteractionEnabled = true
        return slider
    }()
    
    private var playtimeView: UIView = {
        let playtimeView = UIView()
        return playtimeView
    }()
    
    var currentPlayTimeLabel: UILabel = {
        let currentPlayTime = UILabel()
        currentPlayTime.textAlignment = .left
        currentPlayTime.textColor = .white
        currentPlayTime.text = "0:00"
        currentPlayTime.font = UIFont(name: "AvenirNext-Regular", size: 12)
        return currentPlayTime
    }()
    
     var totalPlayTimeLabel: UILabel = {
        let totalPlayTime = UILabel()
        totalPlayTime.textAlignment = .right
        totalPlayTime.textColor = .white
        totalPlayTime.font = UIFont(name: "AvenirNext-Regular", size: 12)
        return totalPlayTime
    }()
    
    var playButton: UIButton = {
        var playButton = UIButton()
        playButton.setImage(#imageLiteral(resourceName: "play-icon"), for: .normal)
        return playButton
    }()
    
    var pauseButton: UIButton = {
        var pauseButton = UIButton()
        pauseButton.setImage(#imageLiteral(resourceName: "white-bordered-pause"), for: .normal)
        return pauseButton
    }()
    
    private var skipButton: UIButton = {
        var skipButton = UIButton()
        skipButton.setImage(#imageLiteral(resourceName: "skip-icon"), for: .normal)
        return skipButton
    }()
    
    private var backButton: UIButton = {
        var backButton = UIButton()
        backButton.setImage(#imageLiteral(resourceName: "back-icon"), for: .normal)
        return backButton
    }()
    
    func configure() {
        setup(trackButton: playButton)
    }
    
    func setup(playtimeSliderView: UIView) {
        addSubview(playtimeSliderView)
        playtimeSliderView.translatesAutoresizingMaskIntoConstraints = false
        playtimeSliderView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        playtimeSliderView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.75).isActive = true
        playtimeSliderView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.08).isActive = true
        playtimeSliderView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: UIScreen.main.bounds.height * 0.05).isActive = true
    }
    
    private func setup(playtimeSlider: UISlider) {
        playtimeSliderView.addSubview(playtimeSlider)
        playtimeSlider.translatesAutoresizingMaskIntoConstraints = false
        playtimeSlider.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        playtimeSlider.centerYAnchor.constraint(equalTo: playtimeSliderView.centerYAnchor).isActive = true
        playtimeSlider.heightAnchor.constraint(equalTo: playtimeSliderView.heightAnchor, multiplier: 0.8).isActive = true
        playtimeSlider.widthAnchor.constraint(equalTo: playtimeSliderView.widthAnchor).isActive = true
    }
    
    private func setup(trackButton: UIButton) {
        addSubview(trackButton)
        trackButton.translatesAutoresizingMaskIntoConstraints = false
        trackButton.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.32).isActive = true
        trackButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.18).isActive = true
        trackButton.bottomAnchor.constraint(equalTo: centerYAnchor).isActive = true
        trackButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
    
    private func setup(playButton: UIButton, pauseButton: UIButton) {
        setup(trackButton: playButton)
        setup(trackButton: pauseButton)
    }
    
    private func skipButtonsSharedLayout(button: UIButton) {
        addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalTo: widthAnchor, multiplier: PlayerViewConstants.backButtonWidthMultiplier).isActive = true
        button.heightAnchor.constraint(equalTo: heightAnchor, multiplier: PlayerViewConstants.backButtonHeightMultiplier).isActive = true
        button.centerYAnchor.constraint(equalTo: playButton.centerYAnchor).isActive = true
    }
    
    private func setup(totalTimeLabel: UILabel) {
        addSubview(totalPlayTimeLabel)
        totalPlayTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        totalPlayTimeLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.1).isActive = true
        totalPlayTimeLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: PlayerViewConstants.backButtonHeightMultiplier).isActive = true
        totalPlayTimeLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: UIScreen.main.bounds.height * -0.05).isActive = true
        totalPlayTimeLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: UIScreen.main.bounds.width * -0.15).isActive = true
    }
    
    private func setup(currentTimeLabel: UILabel) {
        addSubview(currentTimeLabel)
        currentTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        currentTimeLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.1).isActive = true
        currentTimeLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: PlayerViewConstants.backButtonHeightMultiplier).isActive = true
        currentTimeLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: UIScreen.main.bounds.height * -0.05).isActive = true
        currentTimeLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: UIScreen.main.bounds.width * 0.15).isActive = true
    }
    
    private func setup(skipButton: UIButton, backButton: UIButton) {
        skipButtonsSharedLayout(button: skipButton)
        skipButton.rightAnchor.constraint(equalTo: playButton.rightAnchor, constant: UIScreen.main.bounds.width * 0.2).isActive = true
        skipButtonsSharedLayout(button: backButton)
        backButton.leftAnchor.constraint(equalTo: playButton.leftAnchor, constant: UIScreen.main.bounds.width * -0.2).isActive = true
    }
}
