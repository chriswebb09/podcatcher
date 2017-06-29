import UIKit

final class PlayerView: UIView {
    
    weak var delegate: PlayerViewDelegate?
    
    // MARK: - Data Properties
    
    var model: PlayerViewModel! {
        didSet {
            titleLabel.text = model.title
            albumImageView.image = model.imageUrl
            totalPlayTimeLabel.text = model.totalTimeString
        }
    }
    
    // MARK: - UI Element Properties
    
    private var titleView: UIView = {
        let top = UIView()
        top.backgroundColor = PlayerViewConstants.titleViewBackgroundColor
        return top
    }()
    
    private var titleLabel: UILabel = {
        let title = UILabel()
        title.textColor = .white
        title.textAlignment = .center
        title.font = UIFont(name: "Avenir-Light", size: 14)
        return title
    }()
    
    private var activityView: UIView = {
        let activty = UIView()
        activty.backgroundColor = .darkGray
        return activty
    }()
    
    private var albumView: UIView = {
        let album = UIView()
        album.backgroundColor = .lightGray
        return album
    }()
    
    private var albumImageView: UIImageView = {
        let albumImage = UIImageView()
        return albumImage
    }()
    
    private var playtimeSliderView: UIView = {
        let preferences = UIView()
        preferences.backgroundColor = UIColor(red:1.00, green:0.71, blue:0.71, alpha:1.0)
        

            //PlayerViewConstants.preferencesViewBackgroundColor
        return preferences
    }()
    
    private var playtimeSlider: UISlider = {
        let slider = UISlider()
        slider.thumbTintColor = .white
        slider.maximumTrackTintColor = UIColor(red:1.00, green:0.36, blue:0.36, alpha:1.0)
        
        let thumbImage = #imageLiteral(resourceName: "arrow2").scaleToSize(CGSize(width: 20, height: 20))
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
        currentPlayTime.font = UIFont(name: "Avenir-Light", size: 12)
        return currentPlayTime
    }()
    
    private var totalPlayTimeLabel: UILabel = {
        let totalPlayTime = UILabel()
        totalPlayTime.textAlignment = .right
        totalPlayTime.textColor = .white
        totalPlayTime.font = UIFont(name: "Avenir-Light", size: 12)
        return totalPlayTime
    }()
    
    private var controlsView: UIView = {
        let controls = UIView()
        controls.backgroundColor = .semiOffMain
        return controls
    }()
    
    private var playButton: UIButton = {
        var playButton = UIButton()
        playButton.setImage(#imageLiteral(resourceName: "bordered-white-play"), for: .normal)
        return playButton
    }()
    
    private var pauseButton: UIButton = {
        var pauseButton = UIButton()
        pauseButton.setImage(#imageLiteral(resourceName: "white-bordered-pause"), for: .normal)
        return pauseButton
    }()
    
    private var skipButton: UIButton = {
        var skipButton = UIButton()
        skipButton.setImage(#imageLiteral(resourceName: "skip-white-hollow-icon"), for: .normal)
        return skipButton
    }()
    
    private var backButton: UIButton = {
        var backButton = UIButton()
        backButton.setImage(#imageLiteral(resourceName: "back-white-hollow"), for: .normal)
        return backButton
    }()
    
    private var moreButton: UIButton = {
        var moreButton = UIButton()
        moreButton.setImage(#imageLiteral(resourceName: "more-button-white"), for: .normal)
        return moreButton
    }()
    
    private var volumeControlsView: UIView = {
        let volume = UIView()
        return volume
    }()
    
    private var volumeSlider: UISlider = {
        let slider = UISlider()
        slider.thumbTintColor = .white
        slider.tintColor = .white
        slider.isUserInteractionEnabled = true
        return slider
    }()
    
    private var volumeIcon: UIImageView = {
        let volumeIcon = #imageLiteral(resourceName: "low-volume-white")
        let iconView = UIImageView(image: volumeIcon)
        return iconView
    }()
    
    // MARK: - Configuration Methods
    
    func configure(with model: PlayerViewModel) {
        self.model = model
        setupViews()
        pauseButton.alpha = 0
    }
    
    private func sharedLayout(view: UIView) {
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
    }
    
    private func setup(titleView: UIView) {
        sharedLayout(view: titleView)
        titleView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: PlayerViewConstants.trackTitleViewHeightMultiplier).isActive = true
        titleView.topAnchor.constraint(equalTo: topAnchor).isActive = true
    }
    
    private func setup(titleLabel: UILabel) {
        titleView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerXAnchor.constraint(equalTo: titleView.centerXAnchor).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: titleView.centerYAnchor).isActive = true
        titleLabel.heightAnchor.constraint(equalTo: titleView.heightAnchor, multiplier: PlayerViewConstants.trackTitleLabelHeightMultiplier).isActive = true
        titleLabel.widthAnchor.constraint(equalTo: titleView.widthAnchor, multiplier: PlayerViewConstants.trackTitleLabelWidthMultiplier).isActive = true
    }
    
    private func setup(albumView: UIView) {
        sharedLayout(view: albumView)
        albumView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: PlayerViewConstants.artworkViewHeightMultiplier).isActive = true
        albumView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        albumView.topAnchor.constraint(equalTo: titleView.bottomAnchor).isActive = true
    }
    
    private func setup(albumImageView: UIImageView) {
        albumView.addSubview(albumImageView)
        albumImageView.translatesAutoresizingMaskIntoConstraints = false
        albumImageView.centerXAnchor.constraint(equalTo: albumView.centerXAnchor).isActive = true
        albumImageView.centerYAnchor.constraint(equalTo: albumView.centerYAnchor).isActive = true
        albumImageView.heightAnchor.constraint(equalTo: albumView.heightAnchor).isActive = true
        albumImageView.widthAnchor.constraint(equalTo: albumView.widthAnchor).isActive = true
    }
    
    private func setup(sliderView: UIView) {
        sharedLayout(view: sliderView)
        sliderView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: PlayerViewConstants.preferenceHeightMultiplier).isActive = true
        sliderView.topAnchor.constraint(equalTo: albumView.bottomAnchor).isActive = true
    }
    
    private func setup(playtimeSlider: UISlider) {
        playtimeSliderView.addSubview(playtimeSlider)
        playtimeSlider.translatesAutoresizingMaskIntoConstraints = false
        playtimeSlider.centerXAnchor.constraint(equalTo: playtimeSliderView.centerXAnchor).isActive = true
        playtimeSlider.centerYAnchor.constraint(equalTo: playtimeSliderView.centerYAnchor).isActive = true
        playtimeSlider.heightAnchor.constraint(equalTo: playtimeSliderView.heightAnchor, multiplier: PlayerViewConstants.trackTitleLabelHeightMultiplier).isActive = true
        playtimeSlider.widthAnchor.constraint(equalTo: playtimeSliderView.widthAnchor).isActive = true
    }
    
    private func setup(controlsView: UIView) {
        sharedLayout(view: controlsView)
        controlsView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: PlayerViewConstants.controlsViewHeightMultiplier).isActive = true
        controlsView.topAnchor.constraint(equalTo: playtimeSliderView.bottomAnchor).isActive = true
    }
    
    private func setup(trackButton: UIButton) {
        controlsView.addSubview(trackButton)
        trackButton.translatesAutoresizingMaskIntoConstraints = false
        trackButton.heightAnchor.constraint(equalTo: controlsView.heightAnchor, multiplier: 0.4).isActive = true
        trackButton.centerYAnchor.constraint(equalTo: controlsView.centerYAnchor, constant: UIScreen.main.bounds.height * -0.04).isActive = true
        trackButton.centerXAnchor.constraint(equalTo: controlsView.centerXAnchor).isActive = true
    }
    
    private func setup(playButton: UIButton, pauseButton: UIButton) {
        setup(trackButton: playButton)
        playButton.widthAnchor.constraint(equalTo: controlsView.widthAnchor, multiplier: PlayerViewConstants.buttonWidthMultiplier).isActive = true
        setup(trackButton: pauseButton)
        pauseButton.widthAnchor.constraint(equalTo: controlsView.widthAnchor, multiplier: PlayerViewConstants.buttonWidthMultiplier).isActive = true
    }
    
    private func skipButtonsSharedLayout(controlsView: UIView, button: UIButton) {
        controlsView.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalTo: controlsView.widthAnchor, multiplier: PlayerViewConstants.backButtonWidthMultiplier).isActive = true
        button.heightAnchor.constraint(equalTo: controlsView.heightAnchor, multiplier: PlayerViewConstants.backButtonHeightMultiplier).isActive = true
        button.centerYAnchor.constraint(equalTo: controlsView.centerYAnchor, constant: UIScreen.main.bounds.height * -0.04).isActive = true
    }
    
    private func setup(totalTimeLabel: UILabel) {
        controlsView.addSubview(totalPlayTimeLabel)
        totalPlayTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        totalPlayTimeLabel.widthAnchor.constraint(equalTo: controlsView.widthAnchor, multiplier: PlayerViewConstants.backButtonWidthMultiplier).isActive = true
        totalPlayTimeLabel.heightAnchor.constraint(equalTo: controlsView.heightAnchor, multiplier: PlayerViewConstants.backButtonHeightMultiplier).isActive = true
        totalPlayTimeLabel.topAnchor.constraint(equalTo: controlsView.topAnchor, constant: UIScreen.main.bounds.height * 0.005).isActive = true
        totalPlayTimeLabel.rightAnchor.constraint(equalTo: controlsView.rightAnchor, constant: UIScreen.main.bounds.width * -0.04).isActive = true
    }
    
    private func setup(currentTimeLabel: UILabel) {
        controlsView.addSubview(currentTimeLabel)
        currentTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        currentTimeLabel.widthAnchor.constraint(equalTo: controlsView.widthAnchor, multiplier: PlayerViewConstants.backButtonWidthMultiplier).isActive = true
        currentTimeLabel.heightAnchor.constraint(equalTo: controlsView.heightAnchor, multiplier: PlayerViewConstants.backButtonHeightMultiplier).isActive = true
        currentTimeLabel.topAnchor.constraint(equalTo: controlsView.topAnchor, constant: UIScreen.main.bounds.height * 0.005).isActive = true
        currentTimeLabel.leftAnchor.constraint(equalTo: controlsView.leftAnchor, constant: UIScreen.main.bounds.width * 0.04).isActive = true
    }
    
    private func setup(skipButton: UIButton, backButton: UIButton) {
        skipButtonsSharedLayout(controlsView: controlsView, button: skipButton)
        skipButton.rightAnchor.constraint(equalTo: controlsView.rightAnchor, constant: UIScreen.main.bounds.width * -0.16).isActive = true
        skipButtonsSharedLayout(controlsView: controlsView, button: backButton)
        backButton.leftAnchor.constraint(equalTo: controlsView.leftAnchor, constant: UIScreen.main.bounds.width * 0.15).isActive = true
    }
    
    private func setup(volumeControlsView: UIView) {
        controlsView.addSubview(volumeControlsView)
        volumeControlsView.translatesAutoresizingMaskIntoConstraints = false
        volumeControlsView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        volumeControlsView.bottomAnchor.constraint(equalTo: controlsView.bottomAnchor).isActive = true
        volumeControlsView.heightAnchor.constraint(equalTo: controlsView.heightAnchor, multiplier: 0.28).isActive = true
        volumeControlsView.widthAnchor.constraint(equalTo: controlsView.widthAnchor).isActive = true
    }
    
    private func setup(volumeSlider: UISlider) {
        volumeControlsView.addSubview(volumeSlider)
        volumeSlider.translatesAutoresizingMaskIntoConstraints = false
        volumeSlider.rightAnchor.constraint(equalTo: volumeControlsView.rightAnchor, constant: UIScreen.main.bounds.width * -0.16).isActive = true
        volumeSlider.centerYAnchor.constraint(equalTo: volumeControlsView.topAnchor).isActive = true
        volumeSlider.heightAnchor.constraint(equalTo: volumeControlsView.heightAnchor, multiplier: 0.5).isActive = true
        volumeSlider.widthAnchor.constraint(equalTo: volumeControlsView.widthAnchor, multiplier: 0.6).isActive = true
    }
    
    private func setup(volumeImageView: UIImageView) {
        volumeControlsView.addSubview(volumeImageView)
        volumeImageView.translatesAutoresizingMaskIntoConstraints = false
        volumeImageView.leftAnchor.constraint(equalTo: volumeControlsView.leftAnchor, constant: UIScreen.main.bounds.width * 0.15).isActive = true
        volumeImageView.centerYAnchor.constraint(equalTo: volumeControlsView.topAnchor).isActive = true
        volumeImageView.heightAnchor.constraint(equalTo: volumeControlsView.heightAnchor, multiplier: 0.35).isActive = true
        volumeImageView.widthAnchor.constraint(equalTo: volumeControlsView.widthAnchor, multiplier: 0.04).isActive = true
    }
    
    private func setupViews() {
        layoutSubviews()
        setup(titleView: titleView)
        setup(titleLabel: titleLabel)
        setup(albumView: albumView)
        setup(albumImageView: albumImageView)
        setup(sliderView: playtimeSliderView)
        setup(controlsView: controlsView)
        setup(playButton: playButton, pauseButton: pauseButton)
        setup(playtimeSlider: playtimeSlider)
        setup(skipButton: skipButton, backButton: backButton)
        setup(volumeControlsView: volumeControlsView)
        setup(volumeSlider: volumeSlider)
        setup(totalTimeLabel: totalPlayTimeLabel)
        setup(currentTimeLabel: currentPlayTimeLabel)
        setup(volumeImageView: volumeIcon)
        addSelectors()
    }
    
    private func addSelectors() {
        playButton.addTarget(self, action: #selector(playButtonTapped), for: .touchUpInside)
        pauseButton.addTarget(self, action: #selector(pauseButtonTapped), for: .touchUpInside)
        skipButton.addTarget(self, action: #selector(skipButtonTapped), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        playtimeSlider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
    }
    
    // MARK: - Methods
    
    @objc private func sliderValueChanged() {
        let timeString = String.constructTimeString(time: Double(playtimeSlider.value))
        currentPlayTimeLabel.text = timeString
        delegate?.updateTimeValue(time: Double(playtimeSlider.value * 2))
    }
    
    @objc private func playButtonTapped() {
        model.switchButtonAlpha(for: pauseButton, withButton: playButton)
        delegate?.playButtonTapped()
        pauseButton.alpha = 1
    }
    
    @objc private func pauseButtonTapped() {
        model.switchButtonAlpha(for: playButton, withButton: pauseButton)
        delegate?.pauseButtonTapped()
    }
    
    @objc private func skipButtonTapped() {
        model.reset(playButton: playButton, pauseButton: pauseButton, slider: playtimeSlider)
        delegate?.skipButtonTapped()
    }
    
    @objc private func backButtonTapped() {
        model.reset(playButton: playButton, pauseButton: pauseButton, slider: playtimeSlider)
        delegate?.backButtonTapped()
    }
    
    func setPauseButtonAlpha() {
        pauseButton.alpha = 1
    }
    
    func update(progressBarValue: Float) {
        playtimeSlider.value = progressBarValue
    }
}
