import UIKit
import AVFoundation

final class PlayerViewController: BaseViewController {
    
    weak var delegate: PlayerViewControllerDelegate?
    
    // MARK: - UI Properties
    
    var playerView: PlayerView
    var playerState: PlayState
    var dataSource: PodcastListDataSource! 
    var caster: Caster
    var player: AudioFilePlayer?
    var index: Int
    var testIndex: Int
    var user: PodCatcherUser?
    var playerViewModel: PlayerViewModel!
    
    init(playerView: PlayerView = PlayerView(), index: Int, caster: Caster, user: PodCatcherUser?) {
        self.playerView = playerView
        self.index = index
        self.caster = caster
        self.testIndex = index - 1
        self.player = AudioFilePlayer(url: caster.assets[testIndex].audioUrl!)
        self.playerState = .queued
        self.user = user
        super.init(nibName: nil, bundle: nil)
        guard caster.assets.count > 0 else { return }
        guard let artwork = caster.artwork else { return }
        self.playerViewModel = PlayerViewModel(image: artwork, title: caster.assets[testIndex].title)
        setModel(model: PlayerViewModel(image: artwork, title: caster.assets[testIndex].title))
        guard let url = caster.assets[testIndex].audioUrl else { return }
        initPlayer(url: url)
        playerView.delegate = self
        view.addView(view: playerView, type: .full)
        title = caster.assets[testIndex].collectionName
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.alpha = 0
        navigationController?.navigationBar.backItem?.title = "Podcast"
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.popViewController(animated: true)
        tabBarController?.tabBar.alpha = 1
        player?.player.pause()
        player = nil
    }
}
