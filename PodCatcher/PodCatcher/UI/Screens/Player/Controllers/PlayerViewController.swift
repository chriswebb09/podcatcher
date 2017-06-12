import UIKit
import AVFoundation

final class PlayerViewController: UIViewController {
    
    weak var delegate: PlayerViewControllerDelegate?
    
    // MARK: - UI Properties
    
    var playerView: PlayerView
    var playerState: PlayState
    var caster: Caster
    var player: AudioFilePlayer
    var index: Int
    var playerViewModel: PlayerViewModel!
    
    init(playerView: PlayerView = PlayerView(), index: Int, caster: Caster) {
        self.playerView = playerView
        self.index = index
        self.caster = caster
        self.player = AudioFilePlayer(url: caster.assets[index].audioUrl!)
        self.playerState = .queued
        super.init(nibName: nil, bundle: nil)
        edgesForExtendedLayout = []
        guard caster.assets.count > 0 else { return }
        guard let artwork = caster.artwork else { return }
        self.playerViewModel = PlayerViewModel(image: artwork, title: caster.assets[index].title)
        setModel(model: PlayerViewModel(image: artwork, title: caster.assets[index].title))
        initPlayer(url: caster.assets[index].audioUrl!)
        playerView.delegate = self
        view.addView(view: playerView, type: .full)
        title = caster.assets[index].collectionName
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.alpha = 0
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.popViewController(animated: true)
        tabBarController?.tabBar.alpha = 1
    }
    
    func setModel(model: PlayerViewModel) {
        playerView.configure(with: model)
    }
    
    func initPlayer(url: URL)  {
        player = AudioFilePlayer(url: url)
        player.delegate = self
    }
}
