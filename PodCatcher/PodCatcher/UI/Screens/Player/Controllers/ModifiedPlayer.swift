import UIKit
import AVFoundation

final class ModifiedPlayerViewController: BaseViewController {
    
    weak var delegate: PlayerViewControllerDelegate?
    
    // MARK: - UI Properties
    
    var playerView: PlayerView! = PlayerView()
    var playerState: PlayState!
    var episode: Episodes!
    var loadingPop = LoadingPopover()
    var bottomMenu = BottomMenu()
    var caster: CasterSearchResult!
    var menuActive: MenuActive = .none
    var player: AudioFilePlayer?
    var index: Int!
    var testIndex: Int!
    var user: PodCatcherUser?
    let downloadingIndicator = DownloaderIndicatorView()
    var playerViewModel: PlayerViewModel!
    var dataSource = PlayerControllerDataSource()
    
    override func viewWillAppear(_ animated: Bool) {
        showLoadingView(loadingPop: loadingPop)
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        tabBarController?.tabBar.alpha = 0
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.popViewController(animated: true)
        player?.player.pause()
        player = nil
    }
}
