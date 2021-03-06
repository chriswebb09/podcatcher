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
            DispatchQueue.main.async {
                self.currentPlayTimeLabel.text = self.model.currentTimeString
                self.totalPlayTimeLabel.text = self.model.totalTimeString
            }
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
        let customFont = UIFont(name: "Avenir-Medium", size: 16.0)!
        artist.font = customFont
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
        title.font = UIFont(name: "Avenir-Medium", size: 18.0)!
        return title
    }()
    
    private var controls: UIStackView = {
        let controlStack = UIStackView()
        
        return controlStack
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
        slider.minimumValue = 0
        slider.tintColor = .white
        slider.isUserInteractionEnabled = true
        slider.maximumTrackTintColor = UIColor(red:1.00, green:0.71, blue:0.71, alpha:1.0)
        
        let thumbImage = #imageLiteral(resourceName: "line-gray").scaleToSize(CGSize(width: 2.5, height: 18))
        slider.setThumbImage(slider.handleImage(with: .white), for: .normal)
        slider.setThumbImage(thumbImage, for: .selected)
        
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
        currentPlayTime.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.thin)
        
        return currentPlayTime
    }()
    
    var totalPlayTimeLabel: UILabel = UILabel()
    
    private var controlsView: UIView = {
        let controls = UIView()
        controls.backgroundColor = .clear
        return controls
    }()
    
    private var playButton: UIButton = {
        var playButton = UIButton()
        return playButton
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
    
    // MARK: - Configuration Methods
    
    func configure(with model: PlayerViewModel) {
        self.model = model
        setupViews()
        backgroundColor = UIColor(red:0.92, green:0.32, blue:0.33, alpha:1.0)
    }
    
    func updateViewModel(model: PlayerViewModel) {
        self.model = model 
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
        totalPlayTimeLabel.textAlignment = .right
        totalPlayTimeLabel.textColor = .white
        totalPlayTimeLabel.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.thin)
        
        navigationButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            navigationButton.leftAnchor.constraint(equalTo: navBar.leftAnchor, constant: UIScreen.main.bounds.width * 0.01),
            navigationButton.centerYAnchor.constraint(equalTo: navBar.centerYAnchor),
            navigationButton.heightAnchor.constraint(equalTo: navBar.heightAnchor),
            navigationButton.widthAnchor.constraint(equalTo: navBar.widthAnchor, multiplier: 0.12)
            ])
    }
    
    func setup(artistLabel: UILabel) {
        navBar.addSubview(artistLabel)
        artistLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            artistLabel.centerXAnchor.constraint(equalTo: navBar.centerXAnchor),
            artistLabel.centerYAnchor.constraint(equalTo: navBar.centerYAnchor),
            artistLabel.heightAnchor.constraint(equalTo: navBar.heightAnchor),
            artistLabel.widthAnchor.constraint(equalTo: navBar.widthAnchor, multiplier: 0.8)
            ])
    }
    
    private func setup(titleView: UIView) {
        sharedLayout(view: titleView)
        titleView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: PlayerViewConstants.trackTitleViewHeightMultiplier).isActive = true
        titleView.bottomAnchor.constraint(equalTo: centerYAnchor, constant: UIScreen.main.bounds.height * 0.2).isActive = true
    }
    
    func setButtonImages(image: UIImage) {
        DispatchQueue.main.async {
            self.playButton.setImage(image, for: .normal)
        }
    }
    
    private func setup(titleLabel: UILabel) {
        titleView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.centerXAnchor.constraint(equalTo: titleView.centerXAnchor).isActive = true
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: titleView.centerYAnchor, constant: UIScreen.main.bounds.height * 0.046),
            titleLabel.heightAnchor.constraint(equalTo: titleView.heightAnchor, multiplier: PlayerViewConstants.trackTitleLabelHeightMultiplier),
            titleLabel.widthAnchor.constraint(equalTo: titleView.widthAnchor, multiplier: PlayerViewConstants.trackTitleLabelWidthMultiplier)
            ])
    }
    
    private func setup(preferencesView: UIView) {
        addSubview(preferencesView)
        preferencesView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            preferencesView.widthAnchor.constraint(equalTo: widthAnchor),
            preferencesView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: PlayerViewConstants.preferenceHeightMultiplier),
            preferencesView.topAnchor.constraint(equalTo: albumImageView.bottomAnchor, constant: UIScreen.main.bounds.height * 0.02)
            ])
    }
    
    private func setup(moreButton: UIButton) {
        preferencesView.addSubview(moreButton)
        moreButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            moreButton.widthAnchor.constraint(equalTo: preferencesView.widthAnchor, multiplier: PlayerViewConstants.artistInfoWidthMultiplier),
            moreButton.heightAnchor.constraint(equalTo: preferencesView.heightAnchor, multiplier: PlayerViewConstants.artistInfoHeightMultiplier),
            moreButton.rightAnchor.constraint(equalTo: preferencesView.rightAnchor, constant: UIScreen.main.bounds.width * PlayerViewConstants.artistInfoRightOffset),
            moreButton.centerYAnchor.constraint(equalTo: preferencesView.centerYAnchor)
            ])
    }
    
    private func setup(albumView: UIView) {
        sharedLayout(view: albumView)
        NSLayoutConstraint.activate([
            albumView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: PlayerViewConstants.artworkViewHeightMultiplier),
            albumView.centerXAnchor.constraint(equalTo: centerXAnchor),
            albumView.topAnchor.constraint(equalTo: navBar.bottomAnchor)
            ])
    }
    
    private func setup(albumImageView: UIImageView) {
        albumView.addSubview(albumImageView)
        albumImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            albumImageView.centerXAnchor.constraint(equalTo: albumView.centerXAnchor),
            albumImageView.centerYAnchor.constraint(equalTo: albumView.centerYAnchor, constant: UIScreen.main.bounds.height * -0.018),
            albumImageView.heightAnchor.constraint(equalTo: albumView.heightAnchor),
            albumImageView.widthAnchor.constraint(equalTo: albumView.widthAnchor, multiplier: 0.98)
            ])
    }
    
    private func setup(controlsView: UIView) {
        sharedLayout(view: controlsView)
        controlsView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: PlayerViewConstants.controlsViewHeightMultiplier).isActive = true
        controlsView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    private func setup(playButton: UIButton) {
        controlsView.addSubview(playButton)
        playButton.translatesAutoresizingMaskIntoConstraints = false
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 480:
                if #available(iOS 11, *) {
                    NSLayoutConstraint.activate([
                        playButton.heightAnchor.constraint(equalTo: controlsView.heightAnchor, multiplier: 0.40)
                        ])
                } else {
                    NSLayoutConstraint.activate([
                        playButton.heightAnchor.constraint(equalTo: controlsView.heightAnchor, multiplier: 0.44)
                        ])
                }
            case 960:
                if #available(iOS 11, *) {
                    NSLayoutConstraint.activate([
                        playButton.heightAnchor.constraint(equalTo: controlsView.heightAnchor, multiplier: 0.40)
                        ])
                } else {
                    NSLayoutConstraint.activate([
                        playButton.heightAnchor.constraint(equalTo: controlsView.heightAnchor, multiplier: 0.44)
                        ])
                }
            case 1136:
                if #available(iOS 11, *) {
                    NSLayoutConstraint.activate([
                        playButton.heightAnchor.constraint(equalTo: controlsView.heightAnchor, multiplier: 0.40)
                        ])
                } else {
                    NSLayoutConstraint.activate([
                        playButton.heightAnchor.constraint(equalTo: controlsView.heightAnchor, multiplier: 0.44)
                        ])
                }
            case 1334:
                if #available(iOS 11, *) {
                    NSLayoutConstraint.activate([
                        playButton.heightAnchor.constraint(equalTo: controlsView.heightAnchor, multiplier: 0.424)
                        ])
                } else {
                    NSLayoutConstraint.activate([
                        playButton.heightAnchor.constraint(equalTo: controlsView.heightAnchor, multiplier: 0.44)
                        ])
                }
            case 2208:
                if #available(iOS 11, *) {
                    NSLayoutConstraint.activate([
                        playButton.heightAnchor.constraint(equalTo: controlsView.heightAnchor, multiplier: 0.40)
                        ])
                } else {
                    NSLayoutConstraint.activate([
                        playButton.heightAnchor.constraint(equalTo: controlsView.heightAnchor, multiplier: 0.44)
                        ])
                }
            default:
                if #available(iOS 11, *) {
                    NSLayoutConstraint.activate([
                        playButton.heightAnchor.constraint(equalTo: controlsView.heightAnchor, multiplier: 0.40)
                        ])
                } else {
                    NSLayoutConstraint.activate([
                        playButton.heightAnchor.constraint(equalTo: controlsView.heightAnchor, multiplier: 0.44)
                        ])
                }
            }
        }
     
        NSLayoutConstraint.activate([
            playButton.widthAnchor.constraint(equalTo: controlsView.widthAnchor, multiplier: 0.24),
            playButton.bottomAnchor.constraint(equalTo: controlsView.centerYAnchor, constant: UIScreen.main.bounds.height * 0.03),
            playButton.centerXAnchor.constraint(equalTo: controlsView.centerXAnchor)
            ])
    }
    
    private func skipButtonsSharedLayout(controlsView: UIView, button: UIButton) {
        controlsView.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalTo: controlsView.widthAnchor, multiplier: PlayerViewConstants.backButtonWidthMultiplier),
            button.heightAnchor.constraint(equalTo: controlsView.heightAnchor, multiplier: PlayerViewConstants.backButtonHeightMultiplier),
            button.centerYAnchor.constraint(equalTo: playButton.centerYAnchor)
            ])
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
        NSLayoutConstraint.activate([
            playtimeSliderView.centerXAnchor.constraint(equalTo: controlsView.centerXAnchor),
            playtimeSliderView.widthAnchor.constraint(equalTo: controlsView.widthAnchor),
            playtimeSliderView.heightAnchor.constraint(equalTo: controlsView.heightAnchor, multiplier: 0.2),
            playtimeSliderView.centerYAnchor.constraint(equalTo: controlsView.centerYAnchor, constant: UIScreen.main.bounds.height * 0.09)
            ])
    }
    
    private func setup(playtimeSlider: UISlider) {
        playtimeSliderView.addSubview(playtimeSlider)
        
        playtimeSlider.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            playtimeSlider.centerXAnchor.constraint(equalTo: controlsView.centerXAnchor),
            playtimeSlider.centerYAnchor.constraint(equalTo: playtimeSliderView.centerYAnchor),
            playtimeSlider.heightAnchor.constraint(equalTo: playtimeSliderView.heightAnchor),
            playtimeSlider.widthAnchor.constraint(equalTo: playtimeSliderView.widthAnchor)
            ])
    }
    
    private func setup(totalTimeLabel: UILabel) {
        controlsView.addSubview(totalPlayTimeLabel)
        
        totalPlayTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            totalPlayTimeLabel.widthAnchor.constraint(equalTo: controlsView.widthAnchor, multiplier: 0.14),
            totalPlayTimeLabel.heightAnchor.constraint(equalTo: controlsView.heightAnchor, multiplier: PlayerViewConstants.backButtonHeightMultiplier),
            totalPlayTimeLabel.bottomAnchor.constraint(equalTo: controlsView.bottomAnchor, constant: UIScreen.main.bounds.height * -0.012),
            totalPlayTimeLabel.rightAnchor.constraint(equalTo: controlsView.rightAnchor, constant: UIScreen.main.bounds.width * -0.02)
            ])
    }
    
    private func setup(currentTimeLabel: UILabel) {
        controlsView.addSubview(currentTimeLabel)
        
        currentTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            currentTimeLabel.widthAnchor.constraint(equalTo: controlsView.widthAnchor, multiplier: 0.14),
            currentTimeLabel.heightAnchor.constraint(equalTo: controlsView.heightAnchor, multiplier: PlayerViewConstants.backButtonHeightMultiplier),
            currentTimeLabel.bottomAnchor.constraint(equalTo: controlsView.bottomAnchor, constant: UIScreen.main.bounds.height * -0.012),
            currentTimeLabel.leftAnchor.constraint(equalTo: controlsView.leftAnchor, constant: UIScreen.main.bounds.width * 0.02)
            ])
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
        setup(preferencesView: preferencesView)
        setup(moreButton: moreButton)
        setup(playtimeSliderView: playtimeSliderView)
        setup(playtimeSlider: playtimeSlider)
        setup(controlsView: controlsView)
        setup(playButton: playButton)
        setup(skipButton: skipButton, backButton: backButton)
        setup(totalTimeLabel: totalPlayTimeLabel)
        setup(currentTimeLabel: currentPlayTimeLabel)
        
        albumImageView.layer.setCellShadow(contentView: albumImageView)
        
        let rect = CGRect(origin: albumImageView.bounds.origin, size: CGSize(width: albumImageView.bounds.width, height: albumImageView.bounds.height - 10))
        
        let path =  UIBezierPath(roundedRect: rect, cornerRadius: albumImageView.layer.cornerRadius)
        layer.shadowPath = path.cgPath
        addSelectors()
        
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(backButtonTapped))
        rightSwipe.direction = .right
        albumView.addGestureRecognizer(rightSwipe)
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(skipButtonTapped))
        leftSwipe.direction = .left
        albumView.addGestureRecognizer(leftSwipe)
    }
    
    private func addSelectors() {
        playButton.addTarget(self, action: #selector(playButtonTapped), for: .touchUpInside)
        skipButton.addTarget(self, action: #selector(skipButtonTapped), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        moreButton.addTarget(self, action: #selector(moreButtonTapped), for: .touchUpInside)
        navigateBackButton.addTarget(self, action: #selector(navigateBack), for: .touchUpInside)
        playtimeSlider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
    }
    
    // MARK: - Methods
    
    @objc private func sliderValueChanged() {
        let timeString = String.constructTimeString(time: Double(playtimeSlider.value))
        currentPlayTimeLabel.text = timeString
        delegate?.seekTime(value: Double(playtimeSlider.value))
    }
    
    @objc private func playButtonTapped() {
        delegate?.playPause(tapped: true)
    }
    
    @objc private func skipButtonTapped() {
        disableButtons()
        delegate?.skipButton(tapped: true)
    }
    
    @objc private func backButtonTapped() {
        disableButtons()
        delegate?.backButton(tapped: true)
    }
    
    @objc private func moreButtonTapped() {
        delegate?.moreButton(tapped: true)
    }
    
    @objc private func navigateBack() {
        delegate?.navigateBack(tapped: true)
    }
    
    func disableButtons() {
        playButton.isEnabled = false
        skipButton.isEnabled = false
        backButton.isEnabled = false
    }
    
    func setText() {
        DispatchQueue.main.async {
            self.currentPlayTimeLabel.text = self.model.currentTimeString
            self.totalPlayTimeLabel.text = self.model.totalTimeString
        }
    }
    
    func enableButtons() {
        playButton.isEnabled = true
        skipButton.isEnabled = true
        backButton.isEnabled = true
    }
}
