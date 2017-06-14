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
    var user: PodCatcherUser?
    var playerViewModel: PlayerViewModel!
    
    init(playerView: PlayerView = PlayerView(), index: Int, caster: Caster, user: PodCatcherUser?) {
        self.playerView = playerView
        self.index = index
        self.caster = caster
        self.player = AudioFilePlayer(url: caster.assets[index].audioUrl!)
        self.playerState = .queued
        self.user = user
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
        navigationController?.navigationBar.backItem?.title = "Podcast"
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
    
    func getHoursMinutesSecondsFrom(seconds: Double) -> (hours: Int, minutes: Int, seconds: Int) {
        let secs = Int(seconds)
        let hours = secs / 3600
        let minutes = (secs % 3600) / 60
        let seconds = (secs % 3600) % 60
        return (hours, minutes, seconds)
    }
    
    func formatTimeFor(seconds: Double) -> String {
        let result = getHoursMinutesSecondsFrom(seconds: seconds)
        let hoursString = "\(result.hours)"
        var minutesString = "\(result.minutes)"
        if minutesString.characters.count == 1 {
            minutesString = "0\(result.minutes)"
        }
        var secondsString = "\(result.seconds)"
        if secondsString.characters.count == 1 {
            secondsString = "0\(result.seconds)"
        }
        var time = "\(hoursString):"
        if result.hours >= 1 {
            time.append("\(minutesString):\(secondsString)")
        }
        else {
            time = "\(minutesString):\(secondsString)"
        }
        return time
    }
}
