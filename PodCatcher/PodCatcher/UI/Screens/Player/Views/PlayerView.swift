import UIKit

final class PlayerView: UIView {
    
    weak var delegate: PlayerViewDelegate?
    
    // MARK: - Data Properties
    
    private var model: PlayerViewModel! {
        didSet {
            titleLabel.text = model.title
            albumImageView.image = model.imageUrl
            totalPlayTimeLabel.text = model.totalTimeString
            
            model.timer = Timer.init()
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
        preferences.backgroundColor = PlayerViewConstants.preferencesViewBackgroundColor
        return preferences
    }()
    
    private var playtimeSlider: UISlider = {
        let slider = UISlider()
        slider.thumbTintColor = .white
        let thumbImage = #imageLiteral(resourceName: "arrow2").scaleToSize(CGSize(width: 20, height: 20))
        slider.setThumbImage(thumbImage, for: .normal)
        slider.tintColor = .white
        slider.isUserInteractionEnabled = true
        return slider
    }()
    
    private var playtimeView: UIView = {
        let playtimeView = UIView()
        return playtimeView
    }()
    
    private var currentPlayTimeLabel: UILabel = {
        let currentPlayTime = UILabel()
        currentPlayTime.textColor = .white
        currentPlayTime.text = "0:00"
        currentPlayTime.font = UIFont(name: "Avenir-Light", size: 12)
        return currentPlayTime
    }()
    
    private var totalPlayTimeLabel: UILabel = {
        let totalPlayTime = UILabel()
        totalPlayTime.textColor = .white
        totalPlayTime.font = UIFont(name: "Avenir-Light", size: 12)
        return totalPlayTime
    }()
    
    private var controlsView: UIView = {
        let controls = UIView()
        controls.backgroundColor = PlayerViewConstants.controlsViewBackgroundColor
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
        moreButton.setImage(#imageLiteral(resourceName: "morebutton"), for: .normal)
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
        trackButton.heightAnchor.constraint(equalTo: controlsView.heightAnchor, multiplier: 0.35).isActive = true
        trackButton.centerYAnchor.constraint(equalTo: controlsView.centerYAnchor, constant: UIScreen.main.bounds.height * -0.05).isActive = true
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
        button.centerYAnchor.constraint(equalTo: controlsView.centerYAnchor, constant: UIScreen.main.bounds.height * -0.05).isActive = true
    }
    
    func setup(totalTimeLabel: UILabel) {
        controlsView.addSubview(totalPlayTimeLabel)
        totalPlayTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        totalPlayTimeLabel.widthAnchor.constraint(equalTo: controlsView.widthAnchor, multiplier: PlayerViewConstants.backButtonWidthMultiplier).isActive = true
        totalPlayTimeLabel.heightAnchor.constraint(equalTo: controlsView.heightAnchor, multiplier: PlayerViewConstants.backButtonHeightMultiplier).isActive = true
        totalPlayTimeLabel.topAnchor.constraint(equalTo: controlsView.topAnchor).isActive = true
        totalPlayTimeLabel.rightAnchor.constraint(equalTo: controlsView.rightAnchor).isActive = true
    }
    
    func setup(currentTimeLabel: UILabel) {
        controlsView.addSubview(currentTimeLabel)
        currentTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        currentTimeLabel.widthAnchor.constraint(equalTo: controlsView.widthAnchor, multiplier: PlayerViewConstants.backButtonWidthMultiplier).isActive = true
        currentTimeLabel.heightAnchor.constraint(equalTo: controlsView.heightAnchor, multiplier: PlayerViewConstants.backButtonHeightMultiplier).isActive = true
        currentTimeLabel.topAnchor.constraint(equalTo: controlsView.topAnchor).isActive = true
        currentTimeLabel.leftAnchor.constraint(equalTo: controlsView.leftAnchor).isActive = true
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
        volumeControlsView.heightAnchor.constraint(equalTo: controlsView.heightAnchor, multiplier: 0.3).isActive = true
        volumeControlsView.widthAnchor.constraint(equalTo: controlsView.widthAnchor).isActive = true
    }
    
    private func setup(volumeSlider: UISlider) {
        volumeControlsView.addSubview(volumeSlider)
        volumeSlider.translatesAutoresizingMaskIntoConstraints = false
        volumeSlider.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        volumeSlider.centerYAnchor.constraint(equalTo: volumeControlsView.topAnchor).isActive = true
        volumeSlider.heightAnchor.constraint(equalTo: volumeControlsView.heightAnchor, multiplier: 0.5).isActive = true
        volumeSlider.widthAnchor.constraint(equalTo: volumeControlsView.widthAnchor, multiplier: 0.7).isActive = true
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
        print("Playtime slider \(playtimeSlider.value)")
        print(playtimeSlider.value)
        var testString = model.constructTimeString(time: Int(playtimeSlider.value * 100))
        print("TEST STRING \(testString)")
        currentPlayTimeLabel.text = testString
        delegate?.updateTimeValue(time: Double(playtimeSlider.value))
    }
    
    @objc private func playButtonTapped() {
        let timerDic: NSMutableDictionary = ["count": model.time]
        setTimer(timerDict: timerDic)
        model.switchButtonAlpha(for: pauseButton, withButton: playButton)
        delegate?.playButtonTapped()
    }
    
    @objc private func pauseButtonTapped() {
        guard let countDict = model.timer?.userInfo as? NSMutableDictionary else { return }
        model.pauseTime(countdict: countDict)
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
    
    private func setTimer(timerDict: NSMutableDictionary) {
        model.timer?.invalidate()
        model.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateTime), userInfo: timerDict, repeats: true)
    }
    
    @objc private func updateTime() {
        guard let countDict = model.timer?.userInfo as? NSMutableDictionary else { return }
        guard let count = countDict["count"] as? Int else { return }
        model.time = count + 1
        playtimeSlider.value += model.playTimeIncrement
        print("Slider value \(playtimeSlider.value)")
    }
    
  
    
    func updateProgressBar(value: Double) {
        guard var model = model else { return }
        let floatValue = Float(value)
        print("FLOAT \(floatValue)")
        model.progress += floatValue
        var testValue = model.progress * 100
        var testString = model.constructTimeString(time: Int(testValue))
        print("TEST STRING \(testString)")
        currentPlayTimeLabel.text = testString
    }
}
