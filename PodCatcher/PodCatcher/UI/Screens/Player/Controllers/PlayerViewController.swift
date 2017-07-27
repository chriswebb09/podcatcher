import UIKit
import CoreMedia
import CoreData
import AVFoundation

final class PlayerViewController: BaseViewController {
    
    weak var delegate: PlayerViewControllerDelegate?
    
    // MARK: - UI Properties
    
    var playerView = PlayerView()
    var playerState: PlayState!
    var loadingPop: LoadingPopover!
    var bottomMenu = BottomMenu()
    var episodes: [Episodes]!
    var caster: CasterSearchResult
    var menuActive: MenuActive = .none
    var player: AudioFilePlayer
    var index: Int
    let downloadingIndicator = DownloaderIndicatorView()
    var playerViewModel: PlayerViewModel!
    var network: NetworkService = NetworkService()
    
    init(index: Int, caster: CasterSearchResult, image: UIImage?, player: AudioFilePlayer) {
        self.player = player
        
        self.index = index
        self.caster = caster
        self.episodes = caster.episodes
        if let image = image {
            playerView.albumImageView.image = image
        }
        super.init(nibName: nil, bundle: nil)
        network.delegate = self
        if let urlString = caster.episodes[index].audioUrlString,
            let url = URL(string: urlString) {
            player.setUrl(with: url)
            player.playNext(asset: AVURLAsset(url: url))
        }
        self.player.delegate = self
        self.player.observePlayTime()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        CALayer.createGradientLayer(with: [UIColor(red:0.94, green:0.31, blue:0.81, alpha:1.0).cgColor, UIColor(red:0.32, green:0.13, blue:0.70, alpha:1.0).cgColor], layer: playerView.backgroundView.layer, bounds: UIScreen.main.bounds)
        guard let artUrl = caster.podcastArtUrlString else { return }
        DispatchQueue.main.async {
            self.loadingPop = LoadingPopover()
            self.showLoadingView(loadingPop: self.loadingPop)
        }
        playerViewModel = PlayerViewModel(imageUrl: URL(string: artUrl), title: episodes[index].title)
        setModel(model: playerViewModel)
        view.addView(view: playerView, type: .full)
        playerView.delegate = self
        playerState = .queued
        playerView.hidePause()
        playerView.artistLabel.text = caster.podcastArtist
        navigationController?.setNavigationBarHidden(true, animated: false)
        tabBarController?.tabBar.alpha = 0
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        player.removePeriodicTimeObserver()
        navigationController?.popViewController(animated: false)
        player.pause()
        hideLoadingView(loadingPop: loadingPop)
        hidePopMenu()
    }
}

// MARK: - PlayerViewDelegate

extension PlayerViewController: PlayerViewDelegate {
    
    func pauseButton(tapped: Bool) {
        player.pause()
    }
    
    func playButton(tapped: Bool) {
        player.play()
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
    
    func initPlayer(url: URL?)  {
        guard let url = url else { return }
        player.setUrl(with: url)
        player.url = url
        player.playNext(asset: AVURLAsset(url: url))
    }
    
    func updateTimeValue(time: Double) {
        var paused = false
        if player.state == .playing {
            paused = true
            player.pause()
        }
        guard let duration = player.duration else { return }
        player.currentTime = (time * duration) / 100
        DispatchQueue.main.async { [weak self] in
            guard let currentTime = self?.player.currentTime else { return }
            let timeString = String.constructTimeString(time: currentTime)
            self?.playerView.currentPlayTimeLabel.text = timeString
            if paused == true {
                self?.player.play()
            }
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
        player.pause()
        showLoadingView(loadingPop: loadingPop)
        if let urlString = caster.episodes[index].audioUrlString, let url = URL(string: urlString) {
            player.setUrl(with: url)
            player.delegate = self
            self.player.observePlayTime()
            player.playNext(asset: AVURLAsset(url: url))
        }
        updatePlayerViewModel()
    }
    
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
        showPopMenu()
    }
    
    func hidePopMenu() {
        bottomMenu.hideFrom(playerView)
    }
    
    func showPopMenu() {
        bottomMenu.showOn(playerView)
    }
}

extension PlayerViewController: AudioFilePlayerDelegate {
    
    func trackFinishedPlaying() {
        print("Finished")
    }
    
    func trackDurationCalculated(stringTime: String, timeValue: Float64) {
        DispatchQueue.main.async { [weak self] in
            guard let loadingPop = self?.loadingPop, let playerView = self?.playerView else { return }
            self?.playerViewModel.totalTimeString = stringTime
            self?.setModel(model: self?.playerViewModel)
            self?.view.bringSubview(toFront: playerView)
            self?.hideLoadingView(loadingPop: loadingPop)
            self?.playerView.enableButtons()
        }
    }
    
    func updateProgress(progress: Double) {
        guard let duration = player.duration else { return }
        if player.currentTime > 0 && duration > 0 {
            let normalizedTime = player.currentTime * 100.0 / duration
            DispatchQueue.main.async { [weak self] in
                guard let currentTime = self?.player.currentTime else { return }
                self?.playerView.currentPlayTimeLabel.text = String.constructTimeString(time: currentTime)
                self?.playerView.totalPlayTimeLabel.text = String.constructTimeString(time: (duration - currentTime))
                self?.playerView.update(progressBarValue: Float(normalizedTime))
                if normalizedTime >= 100 {
                    self?.player.player.seek(to: kCMTimeZero)
                }
            }
        }
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
        hidePopMenu()
    }
    
    func optionThree(tapped: Bool) {
        print("option three")
    }
    
    func cancel(tapped: Bool) {
        hideLoadingView(loadingPop: loadingPop)
        hidePopMenu()
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
