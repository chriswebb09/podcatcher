import UIKit

final class PlayerView: UIView {
    
    weak var delegate: PlayerViewDelegate?
    
    // MARK: - Data Properties
    
    var model: PlayerViewModel! {
        didSet {
            titleLabel.text = model.title
            if let imageUrl = model.imageUrl {
                albumImageView.downloadImage(url: imageUrl)
            }
            totalPlayTimeLabel.text = model.totalTimeString
        }
    }
    
    var backgroundView = UIView()
    
    // MARK: - UI Element Properties
    
    private var titleView: UIView = {
        let top = UIView()
        return top
    }()
    
    var navBar: UIView = {
        let navBar = UIView()
        return navBar
    }()
    
    private var navigateBackButton: UIButton = {
        var backButton = UIButton()
        var buttonImage = #imageLiteral(resourceName: "back").withRenderingMode(.alwaysTemplate)
        backButton.setImage(buttonImage, for: .normal)
        backButton.tintColor = .white
        return backButton
    }()
    
    var artistLabel: UILabel = {
        let artist = UILabel()
        artist.textColor = .white
        artist.numberOfLines = 0
        artist.textAlignment = .center
        artist.sizeToFit()
        artist.font = UIFont.systemFont(ofSize: 16, weight: UIFontWeightSemibold)
        return artist
    }()
    
    var episodeDescriptionView: UITextView = {
        var descriptionView = UITextView()
        return descriptionView
    }()
    
    private var titleLabel: UILabel = {
        let title = UILabel()
        title.textColor = .white
        title.numberOfLines = 0
        title.textAlignment = .center
        title.sizeToFit()
        title.font = UIFont.systemFont(ofSize: 16, weight: UIFontWeightLight)
        return title
    }()
    
    private var activityView: UIView = {
        let activty = UIView()
        return activty
    }()
    
    private var albumView: UIView = {
        let album = UIView()
        return album
    }()
    
    
    var albumImageView: UIImageView = {
        let albumImage = UIImageView()
        albumImage.layer.setCellShadow(contentView: albumImage)
        return albumImage
    }()
    
    private var preferencesView: UIView = {
        let preferencesView = UIView()
        preferencesView.backgroundColor = .clear
        return preferencesView
    }()
    
    private var playtimeSliderView: UIView = {
        let playtimeSliderView = UIView()
        return playtimeSliderView
    }()
    
    var playtimeSlider: UISlider = {
        let slider = UISlider()
        slider.thumbTintColor = .white
        slider.maximumTrackTintColor = UIColor(red:1.00, green:0.71, blue:0.71, alpha:1.0)
        let thumbImage = #imageLiteral(resourceName: "line-gray").scaleToSize(CGSize(width: 2.5, height: 18))
        //slider.setThumbImage(self.generateHandleImage(thumbImage), for: .normal)
        slider.setThumbImage(slider.generateHandleImage(with: .white), for: .normal)
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
        currentPlayTime.font = UIFont.systemFont(ofSize: 12, weight: UIFontWeightThin)
        return currentPlayTime
    }()
    
    var totalPlayTimeLabel: UILabel = {
        let totalPlayTime = UILabel()
        totalPlayTime.textAlignment = .right
        totalPlayTime.textColor = .white
        totalPlayTime.font = UIFont.systemFont(ofSize: 12, weight: UIFontWeightThin)
        return totalPlayTime
    }()
    
    private var controlsView: UIView = {
        let controls = UIView()
        controls.backgroundColor = .clear
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
        skipButton.setImage(#imageLiteral(resourceName: "skip-icon"), for: .normal)
        return skipButton
    }()
    
    private var backButton: UIButton = {
        var backButton = UIButton()
        backButton.setImage(#imageLiteral(resourceName: "back-icon"), for: .normal)
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
        backgroundColor = .mainColor
    }
    
    private func sharedLayout(view: UIView) {
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
    }
    
    func setup(navBar: UIView) {
        sharedLayout(view: navBar)
        navBar.heightAnchor.constraint(equalTo: heightAnchor, multiplier: PlayerViewConstants.trackTitleViewHeightMultiplier).isActive = true
        navBar.topAnchor.constraint(equalTo: topAnchor, constant: UIScreen.main.bounds.height * 0.01).isActive = true
        navBar.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
    
    func setup(navigationButton: UIButton) {
        navBar.addSubview(navigationButton)
        navigationButton.translatesAutoresizingMaskIntoConstraints = false
        navigationButton.leftAnchor.constraint(equalTo: navBar.leftAnchor, constant: UIScreen.main.bounds.width * 0.01).isActive = true
        navigationButton.centerYAnchor.constraint(equalTo: navBar.centerYAnchor).isActive = true
        navigationButton.heightAnchor.constraint(equalTo: navBar.heightAnchor).isActive = true
        navigationButton.widthAnchor.constraint(equalTo: navBar.widthAnchor, multiplier: 0.12).isActive = true
    }
    
    func setup(artistLabel: UILabel) {
        navBar.addSubview(artistLabel)
        artistLabel.translatesAutoresizingMaskIntoConstraints = false
        artistLabel.centerXAnchor.constraint(equalTo: navBar.centerXAnchor).isActive = true
        artistLabel.centerYAnchor.constraint(equalTo: navBar.centerYAnchor).isActive = true
        artistLabel.heightAnchor.constraint(equalTo: navBar.heightAnchor).isActive = true
        artistLabel.widthAnchor.constraint(equalTo: navBar.widthAnchor, multiplier: 0.8).isActive = true
    }
    
    private func setup(titleView: UIView) {
        sharedLayout(view: titleView)
        titleView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: PlayerViewConstants.trackTitleViewHeightMultiplier).isActive = true
        titleView.bottomAnchor.constraint(equalTo: centerYAnchor, constant: UIScreen.main.bounds.height * 0.2).isActive = true
    }
    
    private func setup(titleLabel: UILabel) {
        titleView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerXAnchor.constraint(equalTo: titleView.centerXAnchor).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: titleView.centerYAnchor, constant: UIScreen.main.bounds.height * 0.046).isActive = true
        titleLabel.heightAnchor.constraint(equalTo: titleView.heightAnchor, multiplier: PlayerViewConstants.trackTitleLabelHeightMultiplier).isActive = true
        titleLabel.widthAnchor.constraint(equalTo: titleView.widthAnchor, multiplier: PlayerViewConstants.trackTitleLabelWidthMultiplier).isActive = true
    }
    
    private func setupPreferencesView(preferencesView: UIView) {
        addSubview(preferencesView)
        preferencesView.translatesAutoresizingMaskIntoConstraints = false
        preferencesView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        preferencesView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: PlayerViewConstants.preferenceHeightMultiplier).isActive = true
        preferencesView.topAnchor.constraint(equalTo: albumImageView.bottomAnchor, constant: UIScreen.main.bounds.height * 0.02).isActive = true
    }
    
    private func setupMoreButton(moreButton: UIButton) {
        preferencesView.addSubview(moreButton)
        moreButton.translatesAutoresizingMaskIntoConstraints = false
        moreButton.widthAnchor.constraint(equalTo: preferencesView.widthAnchor, multiplier: PlayerViewConstants.artistInfoWidthMultiplier).isActive = true
        moreButton.heightAnchor.constraint(equalTo: preferencesView.heightAnchor, multiplier: PlayerViewConstants.artistInfoHeightMultiplier).isActive = true
        moreButton.rightAnchor.constraint(equalTo: preferencesView.rightAnchor, constant: UIScreen.main.bounds.width * PlayerViewConstants.artistInfoRightOffset).isActive = true
        moreButton.centerYAnchor.constraint(equalTo: preferencesView.centerYAnchor).isActive = true
    }
    
    private func setup(albumView: UIView) {
        sharedLayout(view: albumView)
        albumView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: PlayerViewConstants.artworkViewHeightMultiplier).isActive = true
        albumView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        albumView.topAnchor.constraint(equalTo: navBar.bottomAnchor).isActive = true
    }
    
    private func setup(albumImageView: UIImageView) {
        albumView.addSubview(albumImageView)
        albumImageView.translatesAutoresizingMaskIntoConstraints = false
        albumImageView.centerXAnchor.constraint(equalTo: albumView.centerXAnchor).isActive = true
        albumImageView.centerYAnchor.constraint(equalTo: albumView.centerYAnchor, constant: UIScreen.main.bounds.height * -0.018).isActive = true
        albumImageView.heightAnchor.constraint(equalTo: albumView.heightAnchor).isActive = true
        albumImageView.widthAnchor.constraint(equalTo: albumView.widthAnchor, multiplier: 0.96).isActive = true
    }
    
    private func setup(descriptionView: UITextView) {
        
    }
    
    private func setup(controlsView: UIView) {
        sharedLayout(view: controlsView)
        controlsView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: PlayerViewConstants.controlsViewHeightMultiplier).isActive = true
        controlsView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    private func setup(trackButton: UIButton) {
        controlsView.addSubview(trackButton)
        trackButton.translatesAutoresizingMaskIntoConstraints = false
        trackButton.heightAnchor.constraint(equalTo: controlsView.heightAnchor, multiplier: 0.42).isActive = true
        trackButton.widthAnchor.constraint(equalTo: controlsView.widthAnchor, multiplier: 0.24).isActive = true
        trackButton.bottomAnchor.constraint(equalTo: controlsView.centerYAnchor, constant: UIScreen.main.bounds.height * 0.025).isActive = true
        trackButton.centerXAnchor.constraint(equalTo: controlsView.centerXAnchor).isActive = true
    }
    
    private func setup(playButton: UIButton, pauseButton: UIButton) {
        setup(trackButton: playButton)
        setup(trackButton: pauseButton)
        
    }
    
    private func skipButtonsSharedLayout(controlsView: UIView, button: UIButton) {
        controlsView.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalTo: controlsView.widthAnchor, multiplier: PlayerViewConstants.backButtonWidthMultiplier).isActive = true
        button.heightAnchor.constraint(equalTo: controlsView.heightAnchor, multiplier: PlayerViewConstants.backButtonHeightMultiplier).isActive = true
        button.centerYAnchor.constraint(equalTo: playButton.centerYAnchor).isActive = true
    }
    
    private func setup(skipButton: UIButton, backButton: UIButton) {
        skipButtonsSharedLayout(controlsView: controlsView, button: skipButton)
        skipButton.rightAnchor.constraint(equalTo: playButton.rightAnchor, constant: UIScreen.main.bounds.width * 0.27).isActive = true
        skipButtonsSharedLayout(controlsView: controlsView, button: backButton)
        backButton.leftAnchor.constraint(equalTo: playButton.leftAnchor, constant: UIScreen.main.bounds.width * -0.27).isActive = true
    }
    
    
    
    func setup(playtimeSliderView: UIView) {
        controlsView.addSubview(playtimeSliderView)
        playtimeSliderView.translatesAutoresizingMaskIntoConstraints = false
        playtimeSliderView.centerXAnchor.constraint(equalTo: controlsView.centerXAnchor).isActive = true
        playtimeSliderView.widthAnchor.constraint(equalTo: controlsView.widthAnchor, multiplier: 0.85).isActive = true
        playtimeSliderView.heightAnchor.constraint(equalTo: controlsView.heightAnchor, multiplier: 0.2).isActive = true
        playtimeSliderView.centerYAnchor.constraint(equalTo: controlsView.centerYAnchor, constant: UIScreen.main.bounds.height * 0.06).isActive = true
    }
    
    private func setup(playtimeSlider: UISlider) {
        playtimeSliderView.addSubview(playtimeSlider)
        playtimeSlider.translatesAutoresizingMaskIntoConstraints = false
        playtimeSlider.centerXAnchor.constraint(equalTo: controlsView.centerXAnchor).isActive = true
        playtimeSlider.centerYAnchor.constraint(equalTo: playtimeSliderView.centerYAnchor).isActive = true
        playtimeSlider.heightAnchor.constraint(equalTo: playtimeSliderView.heightAnchor).isActive = true
        playtimeSlider.widthAnchor.constraint(equalTo: playtimeSliderView.widthAnchor).isActive = true
    }
    
    private func setup(totalTimeLabel: UILabel) {
        controlsView.addSubview(totalPlayTimeLabel)
        totalPlayTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        totalPlayTimeLabel.widthAnchor.constraint(equalTo: controlsView.widthAnchor, multiplier: 0.14).isActive = true
        totalPlayTimeLabel.heightAnchor.constraint(equalTo: controlsView.heightAnchor, multiplier: PlayerViewConstants.backButtonHeightMultiplier).isActive = true
        totalPlayTimeLabel.bottomAnchor.constraint(equalTo: controlsView.bottomAnchor, constant: UIScreen.main.bounds.height * -0.025).isActive = true
        totalPlayTimeLabel.rightAnchor.constraint(equalTo: controlsView.rightAnchor, constant: UIScreen.main.bounds.width * -0.08).isActive = true
    }
    
    private func setup(currentTimeLabel: UILabel) {
        controlsView.addSubview(currentTimeLabel)
        currentTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        currentTimeLabel.widthAnchor.constraint(equalTo: controlsView.widthAnchor, multiplier: 0.14).isActive = true
        currentTimeLabel.heightAnchor.constraint(equalTo: controlsView.heightAnchor, multiplier: PlayerViewConstants.backButtonHeightMultiplier).isActive = true
        currentTimeLabel.bottomAnchor.constraint(equalTo: controlsView.bottomAnchor, constant: UIScreen.main.bounds.height * -0.025).isActive = true
        currentTimeLabel.leftAnchor.constraint(equalTo: controlsView.leftAnchor, constant: UIScreen.main.bounds.width * 0.08).isActive = true
    }
    
    private func setupViews() {
        backgroundView.frame = frame
        addSubview(backgroundView)
        layoutSubviews()
        setup(titleView: titleView)
        setup(navBar: navBar)
        setup(navigationButton: navigateBackButton)
        setup(artistLabel: artistLabel)
        setup(titleLabel: titleLabel)
        setup(albumView: albumView)
        setup(albumImageView: albumImageView)
        setupPreferencesView(preferencesView: preferencesView)
        setupMoreButton(moreButton: moreButton)
        setup(playtimeSliderView: playtimeSliderView)
        setup(playtimeSlider: playtimeSlider)
        setup(controlsView: controlsView)
        setup(playButton: playButton, pauseButton: pauseButton)
        setup(skipButton: skipButton, backButton: backButton)
        setup(totalTimeLabel: totalPlayTimeLabel)
        setup(currentTimeLabel: currentPlayTimeLabel)
        albumImageView.layer.setCellShadow(contentView: albumImageView)
        let rect = CGRect(origin: albumImageView.bounds.origin, size: CGSize(width: albumImageView.bounds.width, height: albumImageView.bounds.height - 10))
        let path =  UIBezierPath(roundedRect: rect, cornerRadius: albumImageView.layer.cornerRadius)
        layer.shadowPath = path.cgPath
        addSelectors()
        
    }
    
    private func addSelectors() {
        playButton.addTarget(self, action: #selector(playButtonTapped), for: .touchUpInside)
        pauseButton.addTarget(self, action: #selector(pauseButtonTapped), for: .touchUpInside)
        skipButton.addTarget(self, action: #selector(skipButtonTapped), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        playtimeSlider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
        moreButton.addTarget(self, action: #selector(moreButtonTapped), for: .touchUpInside)
        navigateBackButton.addTarget(self, action: #selector(navigateBack), for: .touchUpInside)
    }
    
    // MARK: - Methods
    
    @objc private func sliderValueChanged() {
        let timeString = String.constructTimeString(time: Double(playtimeSlider.value))
        currentPlayTimeLabel.text = timeString
        delegate?.updateTimeValue(time: Double(playtimeSlider.value))
    }
    
    @objc private func playButtonTapped() {
        model.switchButtonAlpha(for: pauseButton, withButton: playButton)
        delegate?.playButtonTapped()
    }
    
    @objc private func pauseButtonTapped() {
        model.switchButtonAlpha(for: playButton, withButton: pauseButton)
        delegate?.pauseButtonTapped()
    }
    
    @objc private func skipButtonTapped() {
        disableButtons()
        delegate?.skipButtonTapped()
        model.reset(playButton: playButton, pauseButton: pauseButton, slider: playtimeSlider)
    }
    
    @objc private func backButtonTapped() {
        disableButtons()
        delegate?.backButtonTapped()
    }
    
    func reset() {
        model.reset(playButton: playButton, pauseButton: pauseButton, slider: playtimeSlider)
    }
    
    @objc private func moreButtonTapped() {
        delegate?.moreButton(tapped: true)
    }
    
    @objc private func navigateBack() {
        delegate?.navigateBack(tapped: true)
    }
    
    func hidePause() {
        pauseButton.alpha = 0
    }
    
    func printSliderBounds() {
        print(playtimeSlider.frame)
    }
    
    func update(progressBarValue: Float) {
        playtimeSlider.value = progressBarValue
        if progressBarValue == 100 {
            reset()
        }
    }
    
    func disableButtons() {
        playButton.isEnabled = false
        skipButton.isEnabled = false
        backButton.isEnabled = false
    }
    
    func enableButtons() {
        playButton.isEnabled = true
        skipButton.isEnabled = true
        backButton.isEnabled = true
    }
}

extension UISlider {
    func generateHandleImage(with color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: self.bounds.size.height / 8, height: self.bounds.size.height + 10)
        return UIGraphicsImageRenderer(size: rect.size).image { imageContext in
            imageContext.cgContext.setFillColor(color.cgColor)
            imageContext.cgContext.fill(rect.insetBy(dx: 0, dy: 10))
        }
    }
}
