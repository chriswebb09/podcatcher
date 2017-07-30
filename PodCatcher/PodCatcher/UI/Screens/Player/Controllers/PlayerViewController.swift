import UIKit
import CoreMedia
import CoreData
import AVFoundation

private var playerViewControllerKVOContext = 0

final class PlayerViewController: BaseViewController {
    
    weak var delegate: PlayerViewControllerDelegate?
    
    // MARK: - UI Properties
    
    var playerView = PlayerView()
    var loadingPop: LoadingPopover = LoadingPopover()
    var bottomMenu = BottomMenu()
    var episodes: [Episodes]!
    var caster: CasterSearchResult
    var menuActive: MenuActive = .none
    
    var player: AudioFilePlayer {
        didSet {
            playerViewModel.state = player.state
        }
    }
    
    var index: Int
    let downloadingIndicator = DownloaderIndicatorView()
    var playerViewModel: PlayerViewModel!
    var network: NetworkService = NetworkService()
    
    init(index: Int, caster: CasterSearchResult, image: UIImage?) {
        self.player = AudioFilePlayer()
        self.index = index
        self.caster = caster
        self.episodes = caster.episodes
        if let image = image { playerView.albumImageView.image = image }
        super.init(nibName: nil, bundle: nil)
        network.delegate = self
        if let urlString = caster.episodes[index].audioUrlString,
            let url = URL(string: urlString) {
            player.asset = AVURLAsset(url: url)
            // player.playNext(asset: AVURLAsset(url: url))
        }
        self.player.delegate = self
        view.addView(view: playerView, type: .full)
    }
    
    private var timeObserverToken: Any?
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        addObserver(self, forKeyPath: #keyPath(PlayerViewController.player.player.currentItem.duration), options: [.new, .initial], context: &playerViewControllerKVOContext)
        addObserver(self, forKeyPath: #keyPath(PlayerViewController.player.player.rate), options: [.new, .initial], context: &playerViewControllerKVOContext)
        addObserver(self, forKeyPath: #keyPath(PlayerViewController.player.player.currentItem.status), options: [.new, .initial], context: &playerViewControllerKVOContext)
        
        
        
        CALayer.createGradientLayer(with: [UIColor(red:0.94, green:0.31, blue:0.81, alpha:1.0).cgColor, UIColor(red:0.32, green:0.13, blue:0.70, alpha:1.0).cgColor], layer: playerView.backgroundView.layer, bounds: UIScreen.main.bounds)
        guard let artUrl = caster.podcastArtUrlString else { return }
        DispatchQueue.main.async {
            self.showLoadingView(loadingPop: self.loadingPop)
        }
        playerViewModel = PlayerViewModel(imageUrl: URL(string: artUrl), title: episodes[index].title)
        setModel(model: playerViewModel)
        playerView.delegate = self
        playerView.hidePause()
        playerView.artistLabel.text = caster.podcastArtist
        navigationController?.setNavigationBarHidden(true, animated: false)
        tabBarController?.tabBar.alpha = 0
        let interval = CMTimeMake(1, 1)
        
        timeObserverToken = player.player.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main) { [unowned self] time in
            let timeElapsed = Float(CMTimeGetSeconds(time))
            self.playerView.playtimeSlider.value = Float(timeElapsed)
            self.playerView.currentPlayTimeLabel.text = String.createTimeString(time: timeElapsed)
            var timeLeft = (Float(self.player.duration) - timeElapsed)
            self.playerView.totalPlayTimeLabel.text = String.createTimeString(time: timeLeft)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        player.removePeriodicTimeObserver()
        navigationController?.popViewController(animated: false)
        hideLoadingView(loadingPop: loadingPop)
        hidePopMenu(playerView)
        
        
        removeObserver(self, forKeyPath: #keyPath(PlayerViewController.player.player.currentItem.duration), context: &playerViewControllerKVOContext)
        removeObserver(self, forKeyPath: #keyPath(PlayerViewController.player.player.rate), context: &playerViewControllerKVOContext)
        removeObserver(self, forKeyPath: #keyPath(PlayerViewController.player.player.currentItem.status), context: &playerViewControllerKVOContext)
        
        if let timeObserverToken = timeObserverToken {
            player.player.removeTimeObserver(timeObserverToken)
            self.timeObserverToken = nil
        }
        
        player.playPause()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        // Make sure the this KVO callback was intended for this view controller.
        guard context == &playerViewControllerKVOContext else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
            return
        }
        
        if keyPath == #keyPath(PlayerViewController.player.player.currentItem.duration) {

            let newDuration: CMTime
            if let newDurationAsValue = change?[NSKeyValueChangeKey.newKey] as? NSValue {
                newDuration = newDurationAsValue.timeValue
                print("new duration \(newDuration)")
            }
            else {
                newDuration = kCMTimeZero
            }
            let hasValidDuration = newDuration.isNumeric && newDuration.value != 0
            let newDurationSeconds = hasValidDuration ? CMTimeGetSeconds(newDuration) : 0.0
            print("new duration seconss \(newDurationSeconds)")
            DispatchQueue.main.async { [weak self] in
                let currentTime = hasValidDuration ? Float(CMTimeGetSeconds((self?.player.player.currentTime())!)) : 0.0
                guard let loadingPop = self?.loadingPop,
                    let playerView = self?.playerView
                    else { return }
                self?.playerViewModel.totalTimeString = String.constructTimeString(time: Double(newDurationSeconds))
                self?.setModel(model: self?.playerViewModel)
                playerView.playtimeSlider.maximumValue = Float(newDurationSeconds)
                playerView.playtimeSlider.value = currentTime
                self?.view.bringSubview(toFront: playerView)
                self?.hideLoadingView(loadingPop: loadingPop)
                self?.playerView.enableButtons()
            }
            
            var currentTimeSeconds = CMTimeGetSeconds(self.player.player.currentTime())
            
            DispatchQueue.main.async { [weak self] in
                guard let currentTime = self?.player.player.currentTime() else { return }
                self?.playerView.currentPlayTimeLabel.text = String.createTimeString(time: Float(currentTimeSeconds))
                if newDurationSeconds > 0 {
                     self?.playerView.totalPlayTimeLabel.text = String.constructTimeString(time: newDurationSeconds - currentTimeSeconds)
                }
                self?.playerView.update(progressBarValue: Float(currentTimeSeconds))
            }
        }
        
        else if keyPath == #keyPath(PlayerViewController.player.player.rate) {
            let newRate = (change?[NSKeyValueChangeKey.newKey] as! NSNumber).doubleValue
            print("new rate \(newRate)")
            let buttonImageName = newRate == 1.0 ? "PauseButton" : "PlayButton"
        }
        else if keyPath == #keyPath(PlayerViewController.player.player.currentItem.status) {
            let newStatus: AVPlayerItemStatus
            
            if let newStatusAsNumber = change?[NSKeyValueChangeKey.newKey] as? NSNumber {
                newStatus = AVPlayerItemStatus(rawValue: newStatusAsNumber.intValue)!
                print("new status \(newStatus)")
            }
            else {
                newStatus = .unknown
            }
            
            if newStatus == .failed {
                handleErrorWithMessage(player.player.currentItem?.error?.localizedDescription, error:player.player.currentItem?.error)
            }
        }
    }
    
    // Trigger KVO for anyone observing our properties affected by player and player.currentItem
    override class func keyPathsForValuesAffectingValue(forKey key: String) -> Set<String> {
        let affectedKeyPathsMappingByKey: [String: Set<String>] = [
            "duration":     [#keyPath(PlayerViewController.player.player.currentItem.duration)],
            "rate":         [#keyPath(PlayerViewController.player.player.rate)]
        ]
        
        return affectedKeyPathsMappingByKey[key] ?? super.keyPathsForValuesAffectingValue(forKey: key)
    }
    
    // MARK: - Error Handling
    
    func handleErrorWithMessage(_ message: String?, error: Error? = nil) {
        NSLog("Error occured with message: \(message), error: \(error).")
        
        let alertTitle = NSLocalizedString("alert.error.title", comment: "Alert title for errors")
        let defaultAlertMessage = NSLocalizedString("error.default.description", comment: "Default error message when no NSError provided")
        
        let alert = UIAlertController(title: alertTitle, message: message == nil ? defaultAlertMessage : message, preferredStyle: UIAlertControllerStyle.alert)
        
        let alertActionTitle = NSLocalizedString("alert.error.actions.OK", comment: "OK on error alert")
        
        let alertAction = UIAlertAction(title: alertActionTitle, style: .default, handler: nil)
        
        alert.addAction(alertAction)
        
        present(alert, animated: true, completion: nil)
    }
    
}


// MARK: - PlayerViewDelegate

extension PlayerViewController: PlayerViewDelegate {
    
    func playPause(tapped: Bool) {
        player.playPause()
        delegate?.playPaused(tapped: true)
        //delegate?.playButton(tapped: caster.episodes[index].audioUrlString!)
        updatePlayerViewModel()
    }

    
    func pauseButton(tapped: Bool) {
        player.playPause()
        delegate?.pauseButton(tapped: caster.episodes[index].audioUrlString!)
        updatePlayerViewModel()
    }
    
    func playButton(tapped: Bool) {
        player.playPause()
        delegate?.playButton(tapped: caster.episodes[index].audioUrlString!)
        updatePlayerViewModel()
    }
    
    func backButton(tapped: Bool) {
        guard index > 0 else { playerView.enableButtons(); return }
        index -= 1
        updateTrack()
        delegate?.backButton(tapped: caster.episodes[index].audioUrlString!)
    }
    
    func skipButton(tapped: Bool) {
        guard index < caster.episodes.count - 1 else { playerView.enableButtons(); return }
        index += 1
        updateTrack()
        delegate?.skipButton(tapped: caster.episodes[index].audioUrlString!)
    }
    
    func setModel(model: PlayerViewModel?) {
        if let model = model {
            playerView.configure(with: model)
        }
    }
    
    func updateTimeValue(time: Double) {
        player.currentTime = (time * player.duration) / 100
        DispatchQueue.main.async { [weak self] in
            guard let currentTime = self?.player.currentTime else { return }
            let timeString = String.constructTimeString(time: currentTime)
            self?.playerView.currentPlayTimeLabel.text = timeString
        }
    }
    
    func updatePlayerViewModel() {
        guard let artUrl = caster.podcastArtUrlString else { return }
        DispatchQueue.main.async { [weak self] in
            guard let index = self?.index, let caster = self?.caster else { return }
            self?.playerViewModel = PlayerViewModel(imageUrl: URL(string: artUrl), title: caster.episodes[index].title)
            guard let model = self?.playerViewModel else { return }
            self?.setModel(model: model)
            self?.title = caster.episodes[index].title
        }
    }
    
    func updateTrack() {
        player.playPause()
        showLoadingView(loadingPop: loadingPop)
        if let urlString = caster.episodes[index].audioUrlString, let url = URL(string: urlString) {
            player.delegate = self
            player.asset = AVURLAsset(url: url)
        }
        updatePlayerViewModel()
        playerViewModel.state = player.state
    }
}

extension PlayerViewController: BottomMenuViewable {
    
    func moreButton(tapped: Bool) {
        let height = view.bounds.height * 0.5
        let width = view.bounds.width
        let size = CGSize(width: width, height: height)
        let originX = view.bounds.width * 0.001
        let originY = view.bounds.height * 0.6
        let origin = CGPoint(x: originX, y: originY)
        bottomMenu.menu.delegate = self
        bottomMenu.setMenu(size)
        bottomMenu.setMenu(origin)
        bottomMenu.setupMenu()
        bottomMenu.setMenu(color: .white,
                           borderColor: .darkGray,
                           textColor: .darkGray)
        showPopMenu(playerView)
    }
}

extension PlayerViewController: AudioFilePlayerDelegate {
    
    func trackFinishedPlaying() {
        print("Finished")
    }
    
    func updateProgress(progress: Double) {

    }
}

extension PlayerViewController: MenuDelegate {
    
    func optionOne(tapped: Bool) {
        hideLoadingView(loadingPop: loadingPop)
        delegate?.addItemToPlaylist(item: caster , index: index)
    }
    
    func optionTwo(tapped: Bool) {
        if let urlString = caster.episodes[index].audioUrlString, !LocalStorageManager.localFileExists(for: urlString) {
            downloadingIndicator.showActivityIndicator(viewController: self)
            let download = Download(url: urlString)
            network.startDownload(download)
        }
        hidePopMenu(playerView)
    }
    
    func optionThree(tapped: Bool) {
        print("option three")
    }
    
    func cancel(tapped: Bool) {
        hideLoadingView(loadingPop: loadingPop)
        hidePopMenu(playerView)
    }
    
    func navigateBack(tapped: Bool) {
        hideLoadingView(loadingPop: loadingPop)
        delegate?.navigateBack(tapped: tapped)
        navigationController?.popViewController(animated: false)
    }
}

extension PlayerViewController: NetworkServiceDelegate {
    
    func download(location set: String) {
        
    }
    
    func download(progress updated: Float) {
        if updated == 1 {
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else { return }
                UIView.animate(withDuration: 0.5) {
                    strongSelf.downloadingIndicator.hideActivityIndicator(viewController: strongSelf)
                }
            }
        }
        print(String(format: "%.1f%%", updated * 100))
    }
}
