import UIKit
import CoreMedia
import CoreData
import AVFoundation

private var playerViewControllerKVOContext = 0

final class PlayerViewController: BaseViewController, ErrorPresenting, LoadingPresenting {
    
    weak var delegate: PlayerViewControllerDelegate?
    
    // MARK: - UI Properties
    var index: Int
    let downloadingIndicator = DownloaderIndicatorView()
    var playerViewModel: PlayerViewModel!
    var network: NetworkService = NetworkService()
    var playerView = PlayerView()
    var loadingPop: LoadingPopover = LoadingPopover()
    var bottomMenu = BottomMenu()
    var episodes: [Episodes]!
    var caster: CasterSearchResult
    var menuActive: MenuActive = .none
    var didPlayToEnd: (() -> ())?
    
    private var didPlayToEndTimeToken: NotificationToken?
    
    @objc var player: AudioFilePlayer {
        didSet {
            playerViewModel.state = player.state
        }
    }
    
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
        }
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
        
        playerViewModel = PlayerViewModel(imageUrl: URL(string: artUrl), title: episodes[index].title)
        setModel(model: playerViewModel)
        playerView.delegate = self
        playerView.artistLabel.text = caster.podcastArtist
        navigationController?.setNavigationBarHidden(true, animated: false)
        tabBarController?.tabBar.alpha = 0
        let interval = CMTimeMake(1, 1)
        
        timeObserverToken = player.player.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main) { [weak self] time in
            let timeElapsed = Float(CMTimeGetSeconds(time))
            DispatchQueue.main.async {
                if let strongSelf = self {
                    strongSelf.playerView.playtimeSlider.value = Float(timeElapsed)
                    strongSelf.playerView.currentPlayTimeLabel.text = String.constructTimeString(time: Double(timeElapsed))
                    let timeLeft = Double(Float(strongSelf.player.duration) - timeElapsed)
                    strongSelf.playerView.totalPlayTimeLabel.text = String.constructTimeString(time: timeLeft)
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        didPlayToEnd = done
        if let playerItem = player.player.currentItem {
            didPlayToEndTimeToken = NotificationCenter.default.addObserver(descriptor: AVPlayerItem.didPlayToEndTime, object: playerItem) { [unowned self] _ in
                self.didPlayToEnd?()
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
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
        didPlayToEndTimeToken = nil
        player.player.pause()
    }
    
    func done() {
        print("done")
    }
    
    private func setupPlayerPeriodicTimeObserver() {
        guard timeObserverToken == nil else { return }
        let time = CMTimeMake(1, 1)
        timeObserverToken = player.player.addPeriodicTimeObserver(forInterval: time, queue: DispatchQueue.main) { [weak self] time in
            guard let strongSelf = self else { return }
            strongSelf.playerView.playtimeSlider.value = Float(CMTimeGetSeconds(time))
            } as AnyObject?
    }
    
    private func cleanUpPlayerPeriodicTimeObserver() {
        if let timeObserverToken = timeObserverToken {
            player.player.removeTimeObserver(timeObserverToken)
            self.timeObserverToken = nil
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == #keyPath(PlayerViewController.player.player.currentItem.duration) {
            let newDuration: CMTime
            if let newDurationAsValue = change?[NSKeyValueChangeKey.newKey] as? NSValue {
                newDuration = newDurationAsValue.timeValue
            } else {
                newDuration = kCMTimeZero
            }
            let hasValidDuration = newDuration.isNumeric && newDuration.value != 0
            let newDurationSeconds = hasValidDuration ? CMTimeGetSeconds(newDuration) : 0.0
            
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else { return }
                guard let loadingPop = self?.loadingPop,
                    let playerView = self?.playerView
                    else { return }
                playerView.playtimeSlider.maximumValue = Float(newDurationSeconds)
                playerView.playtimeSlider.value = 0
                strongSelf.view.bringSubview(toFront: playerView)
                strongSelf.hideLoadingView(loadingPop: loadingPop)
                strongSelf.playerView.enableButtons()
                let currentTime = strongSelf.player.player.currentTime()
                let currentSeconds = CMTimeGetSeconds(currentTime)
                strongSelf.playerView.currentPlayTimeLabel.text = String.constructTimeString(time: Double(currentSeconds))
            }
        } else if keyPath == #keyPath(PlayerViewController.player.player.rate) {
            let newRate = (change?[NSKeyValueChangeKey.newKey] as! NSNumber).doubleValue
            let buttonImageName = newRate == 1.0 ? #imageLiteral(resourceName: "white-bordered-pause") : #imageLiteral(resourceName: "play-icon")
            DispatchQueue.main.async {
                self.playerView.setButtonImages(image: buttonImageName)
            }
        } else if keyPath == #keyPath(PlayerViewController.player.player.currentItem.status) {
            let newStatus: AVPlayerItemStatus
            if let newStatusAsNumber = change?[NSKeyValueChangeKey.newKey] as? NSNumber {
                guard let status =  AVPlayerItemStatus(rawValue: newStatusAsNumber.intValue) else { return }
                newStatus = status
            } else {
                newStatus = .unknown
                DispatchQueue.main.async {
                    self.showLoadingView(loadingPop: self.loadingPop)
                }
            }
            if newStatus == .failed {
                presentError(title: "Error", message: "Error")
            } else if newStatus == .readyToPlay {
                DispatchQueue.main.async { [weak self] in
                    guard let strongSelf = self else { return }
                    guard let currentTime = self?.player.player.currentTime() else { return }
                    let currentSeconds = CMTimeGetSeconds(currentTime)
                    guard let duration = strongSelf.player.player.currentItem?.duration else { return }
                    let durationSeconds = CMTimeGetSeconds(duration)
                    strongSelf.playerView.currentPlayTimeLabel.text = String.constructTimeString(time: Double(currentSeconds))
                    strongSelf.playerView.totalPlayTimeLabel.text = String.constructTimeString(time: durationSeconds)
                }
            }
        }
    }
    
    override class func keyPathsForValuesAffectingValue(forKey key: String) -> Set<String> {
        let affectedKeyPathsMappingByKey: [String: Set<String>] = [
            "duration": [#keyPath(PlayerViewController.player.player.currentItem.duration)],
            "rate": [#keyPath(PlayerViewController.player.player.rate)]
        ]
        return affectedKeyPathsMappingByKey[key] ?? super.keyPathsForValuesAffectingValue(forKey: key)
    }
}


// MARK: - PlayerViewDelegate

extension PlayerViewController: PlayerViewDelegate {
    
    func seekTime(value: Double) {
        let time = CMTime(seconds: value, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        player.player.seek(to: time)
    }
    
    
    func playPause(tapped: Bool) {
        player.playPause()
        guard let artUrl = caster.podcastArtUrlString else { return }
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            guard let index = self?.index, let caster = self?.caster else { return }
            strongSelf.playerViewModel = PlayerViewModel(imageUrl: URL(string: artUrl), title: caster.episodes[index].title)
            guard let model = self?.playerViewModel else { return }
            strongSelf.playerView.updateViewModel(model: model)
            strongSelf.title = caster.episodes[index].title
        }
    }
    
    func backButton(tapped: Bool) {
        guard index > 0 else { playerView.enableButtons(); return }
        index -= 1
        updateTrack()
       
    }
    
    func skipButton(tapped: Bool) {
        guard index < caster.episodes.count - 1 else { playerView.enableButtons(); return }
        index += 1
        updateTrack()
    }
    
    func setModel(model: PlayerViewModel?) {
        if let model = model {
            playerView.configure(with: model)
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
        DispatchQueue.main.async {
            self.showLoadingView(loadingPop: self.loadingPop)
        }
        if let urlString = caster.episodes[index].audioUrlString, let url = URL(string: urlString) {
            player.asset = AVURLAsset(url: url)
        }
        updatePlayerViewModel()
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
        bottomMenu.setMenu(color: .white, borderColor: .darkGray, textColor: .darkGray)
        showPopMenu(playerView)
    }
}

extension PlayerViewController: MenuDelegate {
    
    func optionOne(tapped: Bool) {
        hideLoadingView(loadingPop: loadingPop)
        print(caster)
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
        print(set)
    }
    
    func download(progress updated: Float) {
        if updated == 1 {
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else { return }
                UIView.animate(withDuration: 0.5) {
                    strongSelf.downloadingIndicator.hideActivityIndicator(viewController: strongSelf)
                    strongSelf.view.sendSubview(toBack: strongSelf.downloadingIndicator)
                }
            }
        }
        print(String(format: "%.1f%%", updated * 100))
    }
}
