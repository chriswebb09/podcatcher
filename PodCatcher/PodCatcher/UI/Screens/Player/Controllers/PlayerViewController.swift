import UIKit

final class PlayerViewController: UIViewController {
    
    weak var delegate: PlayerViewControllerDelegate?
    
    // MARK: - Properties
    
    fileprivate var playerView: PlayerView!
    var playerState: PlayState!
    var caster: Caster
    var index: Int!
    var playerViewModel: PlayerViewModel!
    
    init(playerView: PlayerView = PlayerView(), index: Int, caster: Caster) {
        self.playerView = playerView
        self.index = index
        self.caster = caster
        super.init(nibName: nil, bundle: nil)
        playerState = .queued
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        edgesForExtendedLayout = []
        guard caster.assets.count > 0 else { return }
        guard let artwork = caster.artwork else { return }
        setModel(model: PlayerViewModel(title: caster.assets[index].title, timer: nil, progressIncrementer: 0, time: 0, progress: 0, imageUrl: artwork))
        view.addView(view: playerView, type: .full)
        title = caster.assets[index].collectionName
        playerState = .queued
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.alpha = 0
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.popViewController(animated: true)
        self.tabBarController?.tabBar.alpha = 1
    }
    
    func setModel(model: PlayerViewModel) {
        playerView.configure(with: model)
    }
}

extension PlayerViewController: PlayerViewDelegate {
    
    func backButtonTapped() {
        guard var index = index else { return }
        index -= 1
    }

    func skipButtonTapped() {
        guard var index = index, index > 0 else { return }
        index += 1
    }

    func pauseButtonTapped() {
        
    }

    func playButtonTapped() {
        
    }
}

