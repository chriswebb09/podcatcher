import UIKit
import AVFoundation

final class PlayerViewController: BaseViewController {
    
    weak var delegate: PlayerViewControllerDelegate?
    
    // MARK: - UI Properties
    
    var playerView: PlayerView
    var playerState: PlayState
    var loadingPop = LoadingPopover()
    var bottomMenu = BottomMenu()
    var episodes: [Episodes]!
    var caster: CasterSearchResult
    var menuActive: MenuActive = .none
    var player: AudioFilePlayer
    var index: Int
    var user: PodCatcherUser?
    let downloadingIndicator = DownloaderIndicatorView()
    var playerViewModel: PlayerViewModel!
    
    init(playerView: PlayerView = PlayerView(), index: Int, caster: CasterSearchResult, user: PodCatcherUser?) {
        self.playerView = playerView
         CALayer.createGradientLayer(with: [UIColor(red:0.94, green:0.31, blue:0.81, alpha:1.0).cgColor, UIColor(red:0.32, green:0.13, blue:0.70, alpha:1.0).cgColor], layer: playerView.backgroundView.layer, bounds: UIScreen.main.bounds)
        self.index = index
        self.caster = caster
        self.episodes = caster.episodes
        if let url = episodes[index].audioUrlString, let audioUrl = URL(string: url) {
            self.player = AudioFilePlayer(url: audioUrl)
            self.player.setUrl(with: audioUrl)
        } else {
            self.player = AudioFilePlayer()
        }
        self.playerState = .queued
        super.init(nibName: nil, bundle: nil)
        self.player.delegate = self
        self.player.observePlayTime()
        
        guard let artUrl = caster.podcastArtUrlString else { return }
        playerViewModel = PlayerViewModel(imageUrl: URL(string: artUrl), title: episodes[index].title)
        setModel(model: playerViewModel)
        playerView.delegate = self
        view.addView(view: playerView, type: .full)
        self.playerView.hidePause()
        self.playerView.artistLabel.text = caster.podcastArtist
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        showLoadingView(loadingPop: loadingPop)
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        tabBarController?.tabBar.alpha = 0
        DispatchQueue.main.async {
            self.playerView.hidePause()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        player.removePeriodicTimeObserver()
        navigationController?.popViewController(animated: false)
        player.pause()
        DispatchQueue.main.async {
            self.hideLoadingView(loadingPop: self.loadingPop)
            self.hidePopMenu()
        }
    }
}
