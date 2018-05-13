 import UIKit
 import CoreMedia
 import CoreData
 import AVFoundation
 import Reachability
 
 private var playerViewControllerKVOContext = 0
 
 final class PlayerViewController: BaseViewController {
    
    weak var delegate: PlayerViewControllerDelegate?
    
    // MARK: - UI Properties
    
    private var index: Int
    private let downloadingIndicator = DownloaderIndicatorView()
    private var playerViewModel: PlayerViewModel!
    private var network: NetworkService = NetworkService()
    private var playerView = PlayerView()
    private var loadingPop: LoadingPopover = LoadingPopover()
    
    var bottomMenu = BottomMenu()
    
    private(set) var caster: PodcastItem
    
    var menuActive: MenuActive = .none
    
    private let reachability = Reachability()!
    
    @objc var player: AudioFilePlayer? {
        didSet {
            guard let player = player, let state = player.state else { return }
            playerViewModel.state = state
        }
    }
    
    init(index: Int, caster: PodcastItem, image: UIImage?) {
        player = AudioFilePlayer()
        self.index = index
        self.caster = caster
        
        if let image = image {
            playerView.albumImageView.image = image
        }
        super.init(nibName: nil, bundle: nil)
        network.delegate = self
        if let url = URL(string: caster.episodes[index].mediaString) {
            if LocalStorageManager.localFileExists(for: caster.episodes[index].mediaString) {
                let newUrl = LocalStorageManager.localFilePath(for: url)
                player?.asset = AVURLAsset(url: newUrl)
            } else {
                player?.asset = AVURLAsset(url: url)
            }
        }
        view.addView(view: playerView, type: .full)
    }
    
    private var timeObserverToken: Any?
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: NSNotification.Name(rawValue: "ReachabilityDidChangeNotificationName"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadingPop.isHidden = false
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        done()
    }
 }
 
 extension PlayerViewController: LoadingPresenting, ErrorPresenting {
    
    func setupPlayerView() {
        playerView.alpha = 1
        view.bringSubview(toFront: playerView)
        tabBarController?.tabBar.alpha = 1
    }
    
    func setup() {
        addObserver(self, forKeyPath: #keyPath(PlayerViewController.player.player.currentItem.duration), options: [.new, .initial], context: &playerViewControllerKVOContext)
        addObserver(self, forKeyPath: #keyPath(PlayerViewController.player.player.rate), options: [.new, .initial], context: &playerViewControllerKVOContext)
        addObserver(self, forKeyPath: #keyPath(PlayerViewController.player.player.currentItem.status), options: [.new, .initial], context: &playerViewControllerKVOContext)
        
        CALayer.createGradientLayer(with: StartViewConstants.gradientColors, layer: playerView.backgroundView.layer, bounds: UIScreen.main.bounds)
        
       // guard let artUrl = caster.podcastArtUrlString else { return }
        
        playerViewModel = PlayerViewModel(imageUrl: URL(string: caster.podcastArtUrlString), title: caster.episodes[index].title)
        playerView.configure(with: playerViewModel)
        playerView.delegate = self
        
        playerView.artistLabel.text = caster.podcastArtist
        navigationController?.setNavigationBarHidden(true, animated: false)
        tabBarController?.tabBar.alpha = 0
        
        let interval = CMTimeMake(1, 1)
        
        timeObserverToken = player?.player?.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main) { [weak self] time in
            
            let timeElapsed = Float(CMTimeGetSeconds(time))
            
            if let strongSelf = self {
                DispatchQueue.main.async {
                    
                    strongSelf.playerView.playtimeSlider.value = Float(timeElapsed)
                    strongSelf.playerView.currentPlayTimeLabel.text = String.constructTimeString(time: Double(timeElapsed))
                    let timeLeft = Double(Float((strongSelf.player?.duration)!) - timeElapsed)
                    strongSelf.playerView.totalPlayTimeLabel.text = String.constructTimeString(time: timeLeft)
                }
            }
        }
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged), name: Notification.Name.reachabilityChanged, object: reachability)
        do {
            try reachability.startNotifier()
        } catch {
            print("could not start reachability notifier")
        }
    }
    
    func done() {
        
        navigationController?.popViewController(animated: false)
        hideLoadingView(loadingPop: loadingPop)
        
        hidePopMenu(playerView)
        
        removeObserver(self, forKeyPath: #keyPath(PlayerViewController.player.player.currentItem.duration), context: &playerViewControllerKVOContext)
        removeObserver(self, forKeyPath: #keyPath(PlayerViewController.player.player.rate), context: &playerViewControllerKVOContext)
        removeObserver(self, forKeyPath: #keyPath(PlayerViewController.player.player.currentItem.status), context: &playerViewControllerKVOContext)
        
        player?.player?.removeTimeObserver(timeObserverToken ?? "token")
        
        self.timeObserverToken = nil
        
        if let timeObserverToken = timeObserverToken {
            player?.player?.removeTimeObserver(timeObserverToken)
        }
        
        reachability.stopNotifier()
        
        NotificationCenter.default.removeObserver(self, name: Notification.Name.reachabilityChanged, object: reachability)
        
        player?.player?.pause()
        
        self.player?.asset = nil
        self.player?.currentTime = nil
        self.player?.delegate = nil
        self.player?.playerItem = nil
        self.player?.state = nil
        self.player?.player = nil
        self.player = nil
    }
    
    func hideLoadingIndicator() {
        loadingPop.isHidden = true 
    }
    
    @objc func reachabilityChanged(note: Notification) {
        if reachability.connection != .none {
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.updateTrack()
            }
            
        } else if reachability.connection != .none {
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.hideLoadingView(loadingPop: strongSelf.loadingPop)
                strongSelf.presentError(title: "Connect To Network", message: "You must be connected to the internet to stream context.")
            }
        }
    }
    
    private func setupPlayerPeriodicTimeObserver() {
        guard timeObserverToken == nil else { return }
        let time = CMTimeMake(1, 1)
        timeObserverToken = player?.player?.addPeriodicTimeObserver(forInterval: time, queue: DispatchQueue.main) { [weak self] time in
            guard let strongSelf = self else { return }
            strongSelf.playerView.playtimeSlider.value = Float(CMTimeGetSeconds(time))
            } as AnyObject?
    }
    
    private func cleanUpPlayerPeriodicTimeObserver() {
        if let timeObserverToken = timeObserverToken { 
            player?.player?.removeTimeObserver(timeObserverToken)
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
                
                strongSelf.playerView.playtimeSlider.maximumValue = Float(newDurationSeconds)
                strongSelf.playerView.playtimeSlider.value = 0
                strongSelf.view.bringSubview(toFront: strongSelf.playerView)
                strongSelf.hideLoadingView(loadingPop: strongSelf.loadingPop)
                
                strongSelf.playerView.enableButtons()
                guard let player = strongSelf.player, let audioPlayer = player.player else { return }
                let currentSeconds = CMTimeGetSeconds(audioPlayer.currentTime())
                strongSelf.playerView.currentPlayTimeLabel.text = String.constructTimeString(time: Double(currentSeconds))
            }
        } else if keyPath == #keyPath(PlayerViewController.player.player.rate) {
            
            if let rateChange = change, let newRate = rateChange[NSKeyValueChangeKey.newKey] as? NSNumber {
                
                let buttonImageName = Double(truncating: newRate) == 1.0 ? #imageLiteral(resourceName: "white-bordered-pause") : #imageLiteral(resourceName: "play-icon")
                DispatchQueue.main.async { [weak self] in
                    guard let strongSelf = self else { return }
                    strongSelf.playerView.setButtonImages(image: buttonImageName)
                }
            }
        } else if keyPath == #keyPath(PlayerViewController.player.player.currentItem.status) {
            let newStatus: AVPlayerItemStatus
            if let newStatusAsNumber = change?[NSKeyValueChangeKey.newKey] as? NSNumber {
                guard let status =  AVPlayerItemStatus(rawValue: newStatusAsNumber.intValue) else { return }
                newStatus = status
            } else {
                newStatus = .unknown
            }
            if newStatus == .failed {
                presentError(title: "Error", message: "Error")
            } else if newStatus == .readyToPlay {
                DispatchQueue.main.async { [weak self] in
                    
                    guard let strongSelf = self, let player = strongSelf.player, let audioPlayer = player.player, let currentItem = audioPlayer.currentItem else { return }
                    
                    let currentSeconds = CMTimeGetSeconds(audioPlayer.currentTime())
                    let durationSeconds = CMTimeGetSeconds(currentItem.duration)
                    strongSelf.playerView.model.setTimeStrings(total: String.constructTimeString(time: durationSeconds), current: String.constructTimeString(time: Double(currentSeconds)))
                    strongSelf.playerView.setText()
                    
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
    
    internal func seekTime(value: Double) {
        let time = CMTime(seconds: value, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        if let player = self.player, let audioPlayer = player.player {
            audioPlayer.seek(to: time)
        }
    }
    
    
    internal func playPause(tapped: Bool) {
        if reachability.connection != .none {
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self, let player = strongSelf.player, let audioPlayer = player.player else { return }
                strongSelf.presentError(title: "Connect To Network", message: "You must be connected to the internet to stream context.")
                if audioPlayer.currentItem?.status != .readyToPlay {
                    let buttonImageName = #imageLiteral(resourceName: "play-icon")
                    strongSelf.playerView.setButtonImages(image: buttonImageName)
                }
                return
            }
        }
        player?.playPause()
   //     guard let artUrl = caster.podcastArtUrlString else { return }
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            
            strongSelf.playerViewModel = PlayerViewModel(imageUrl: URL(string: strongSelf.caster.podcastArtUrlString), title: strongSelf.caster.episodes[strongSelf.index].title)
            strongSelf.playerView.updateViewModel(model: strongSelf.playerViewModel)
            strongSelf.title = strongSelf.caster.episodes[strongSelf.index].title
        }
    }
    
    internal func backButton(tapped: Bool) {
        guard index > 0 else { playerView.enableButtons(); return }
        index -= 1
        updateTrack()
    }
    
    internal func skipButton(tapped: Bool) {
        guard index < caster.episodes.count - 1 else { playerView.enableButtons(); return }
        index += 1
        updateTrack()
    }
    
    private func updatePlayerViewModel() {
     //   guard let artUrl = caster.podcastArtUrlString else { return }
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.playerViewModel = PlayerViewModel(imageUrl: URL(string: strongSelf.caster.podcastArtUrlString),
                                                         title: strongSelf.caster.episodes[strongSelf.index].title)
            guard let model = strongSelf.playerViewModel else { return }
            strongSelf.playerView.configure(with: model)
            strongSelf.title = strongSelf.caster.episodes[strongSelf.index].title
        }
    }
    
    private func updateTrack() {
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.showLoadingView(loadingPop: strongSelf.loadingPop)
        }
        if let url = URL(string: caster.episodes[index].mediaString) {
            if LocalStorageManager.localFileExists(for: caster.episodes[index].mediaString) {
                let newUrl = LocalStorageManager.localFilePath(for: url)
                player?.asset = AVURLAsset(url: newUrl)
            } else {
                player?.asset = AVURLAsset(url: url)
            }
        }
        updatePlayerViewModel()
    }
 }
 
 extension PlayerViewController: BottomMenuViewable {
    
    func moreButton(tapped: Bool) {
        menuSetup()
        bottomMenu.menu.delegate = self
        showPopMenu(playerView)
    }
 }
 
 extension PlayerViewController: MenuDelegate {
    
    func optionOne(tapped: Bool) {
        hideLoadingView(loadingPop: loadingPop)
        delegate?.addItemToPlaylist(item: caster , index: index)
        
      //  if let urlString = caster.episodes[index].audioUrlString, !LocalStorageManager.localFileExists(for: urlString) {
            downloadingIndicator.showActivityIndicator(viewController: self)
            let download = Download(url: caster.episodes[index].mediaString)
            network.startDownload(download)
       // }
    }
    
    func optionTwo(tapped: Bool) {
        
        if !LocalStorageManager.localFileExists(for: caster.episodes[index].mediaString) {
            downloadingIndicator.showActivityIndicator(viewController: self)
            let download = Download(url: caster.episodes[index].mediaString)
            network.startDownload(download)
            delegate?.saveItemCoreData(item: caster, index: index, image: playerView.albumImageView.image!)
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
        delegate?.navigateBack(tapped: tapped)
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
