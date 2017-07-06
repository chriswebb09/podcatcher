import UIKit
import AVFoundation

final class PlayerViewController: BaseViewController {
    
    weak var delegate: PlayerViewControllerDelegate?
    
    // MARK: - UI Properties
    
    var playerView: PlayerView
    var playerState: PlayState
    var episode: Episodes!
    var loadingPop = LoadingPopover()
    var bottomMenu = BottomMenu()
    var caster: CasterSearchResult
    var menuActive: MenuActive = .none
    var player: AudioFilePlayer?
    var index: Int
    var testIndex: Int
    var user: PodCatcherUser?
    let downloadingIndicator = DownloaderIndicatorView()
    var playerViewModel: PlayerViewModel!
    
    init(playerView: PlayerView = PlayerView(), index: Int, caster: CasterSearchResult, user: PodCatcherUser?) {
        self.playerView = playerView
        self.index = index
        self.caster = caster
        self.testIndex = index - 1
        if let url = caster.episodes[index].audioUrlString, let audioUrl = URL(string: url) {
            self.player = AudioFilePlayer(url: audioUrl)
        }
        self.playerState = .queued
        super.init(nibName: nil, bundle: nil)
        player?.delegate = self
        guard let artUrl = caster.podcastArtUrlString else { return }
        playerViewModel = PlayerViewModel(imageUrl: URL(string: artUrl), title: caster.episodes[index].title)
        setModel(model: playerViewModel)
        playerView.delegate = self
        view.addView(view: playerView, type: .full)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        showLoadingView(loadingPop: loadingPop)
        super.viewWillAppear(animated)
        tabBarController?.tabBar.alpha = 0
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.navigationBar.alpha = 1
        navigationController?.popViewController(animated: true)
        tabBarController?.tabBar.alpha = 1
        player?.player.pause()
        player = nil
    }
}
