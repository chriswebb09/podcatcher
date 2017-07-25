import UIKit
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
    var player: AudioFilePlayer?
    var index: Int
    var user: PodCatcherUser?
    let downloadingIndicator = DownloaderIndicatorView()
    var playerViewModel: PlayerViewModel!
    var network: NetworkService = NetworkService()
    
    init(index: Int, caster: CasterSearchResult, user: PodCatcherUser?, image: UIImage?) {
        self.index = index
        self.caster = caster
        self.episodes = caster.episodes
        if let image = image {
            playerView.albumImageView.image = image
        }
        super.init(nibName: nil, bundle: nil)
        network.delegate = self
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
        loadAudioFile()
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
        player?.removePeriodicTimeObserver()
        navigationController?.popViewController(animated: false)
        player?.pause()
        hideLoadingView(loadingPop: loadingPop)
        hidePopMenu()
    }
}
