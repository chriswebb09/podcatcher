
import UIKit
import CoreData
import AVFoundation

final class ListTopView: UIView, BaseView {
    
    let concurrentPhotoQueue = DispatchQueue( label: "com.Queue", attributes: .concurrent)
    
    // MARK: - UI Properties
    
    var podcastImageView: UIImageView! = {
        var podcastImageView = UIImageView()
        podcastImageView.layer.cornerRadius = 3
        podcastImageView.layer.borderWidth = 1
        podcastImageView.layer.borderColor = UIColor.lightGray.cgColor
        return podcastImageView
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setup()
        backgroundColor = .white
        layer.setCellShadow(contentView: self)
        autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    func setupBackground() {
        concurrentPhotoQueue.async(flags: .assignCurrentContext) {
            DispatchQueue.main.async {
                let background = UIImageView()
                background.image = self.podcastImageView.image
                background.frame = CGRect(x: self.frame.minX, y: self.frame.minY - 4, width: self.frame.width, height: self.frame.height)
                self.add(background)
                background.addBlurEffect()
                self.bringSubview(toFront: self.podcastImageView)
                background.alpha = 0.6
            }
        }
    }
    
    func setup() {
        setup(podcastImageView: podcastImageView)
    }
    
    func setup(podcastImageView: UIImageView) {
        addSubview(podcastImageView)
        podcastImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            podcastImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            podcastImageView.centerXAnchor.constraint(equalTo: centerXAnchor)
            ])
        if #available(iOS 11, *) {
            NSLayoutConstraint.activate([
                podcastImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.8),
                podcastImageView.widthAnchor.constraint(equalTo: heightAnchor, multiplier: 0.8)
                ])
        } else {
            NSLayoutConstraint.activate([
                podcastImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: PodcastListTopViewConstants.imageHeightMultiplier),
                podcastImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: PodcastListTopViewConstants.imageWidthMultiplier)
                ])
        }
        podcastImageView.layoutIfNeeded()
        layoutIfNeeded()
    }
    
    func configureTopImage() {
        podcastImageView.dropShadow()
    }
}

private var playlistViewControllerKVOContext = 1

class PlaylistViewController: BaseTableViewController {
    
    var playlist: Playlist!
    var cellModels: [DownloadedCellViewModel] = []
    var audioPlayer: AudioFilePlayer!
    
    var items: [Episodes] = []
    var topView = ListTopView()
    var mode: PlaylistsInteractionMode = .add
    
    var name: String!
    var playlistId: String!
    var selectedIndex: IndexPath!
    var miniPlayer: MiniPlayerViewController!
    
    var playerContainer: UIView = UIView()
    
    var topViewHeightConstraint: NSLayoutConstraint!
    var topViewWidthConstraint: NSLayoutConstraint!
    var topViewYConstraint: NSLayoutConstraint!
    var topViewXConstraint: NSLayoutConstraint!
    var topViewTopConstraint: NSLayoutConstraint!
    var topViewBottomConstraint: NSLayoutConstraint!
    
    var background = UIView()
    var persistentContainer: NSPersistentContainer!
    
    var managedContext: NSManagedObjectContext! {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        let context = appDelegate.persistentContainer.viewContext
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return context
    }
    
    enum PlaylistsInteractionMode {
        case add, edit
    }
    
    lazy var fetchedResultsController:NSFetchedResultsController<Playlist> = {
        let fetchRequest:NSFetchRequest<Playlist> = Playlist.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "dateCreated", ascending: true)]
        fetchRequest.predicate = NSPredicate(format: "playlistId == %@", playlistId)
        var controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedContext, sectionNameKeyPath: nil, cacheName: nil)
        do {
            try? controller.performFetch()
        }
        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
        edgesForExtendedLayout = []
        tableView.register(DownloadedCell.self, forCellReuseIdentifier: DownloadedCell.reuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        
        configureTopView()
        playlist = fetchedResultsController.fetchedObjects![0]
        view.add(topView)
        setupTopView()
        setupTableView()
        rightButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(self.edit))
        
        NotificationCenter.default.addObserver(self, selector: #selector(audioPlayerWillStartPlaying(_:)), name: .audioPlayerWillStartPlaying, object: audioPlayer)
        NotificationCenter.default.addObserver(self, selector: #selector(audioPlayerDidStartLoading(_:)), name: .audioPlayerDidStartLoading, object: audioPlayer)
        NotificationCenter.default.addObserver(self, selector: #selector(audioPlayerDidStartPlaying(_:)), name: .audioPlayerDidStartPlaying, object: audioPlayer)
        NotificationCenter.default.addObserver(self, selector: #selector(audioPlayerDidPause(_:)), name: .audioPlayerDidPause, object: audioPlayer)
        NotificationCenter.default.addObserver(self, selector: #selector(audioPlayerPlaybackTimeChanged(_:)), name: .audioPlayerPlaybackTimeChanged, object: audioPlayer)
        
        setupPlayer()
    }
    
    func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: topView.bottomAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    func setupTopView() {
        topView.translatesAutoresizingMaskIntoConstraints = false
        topView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        topView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        topView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        topView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3).isActive = true
    }
    
    func setupPlayer() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        audioPlayer = appDelegate.audioPlayer
        setupModels()
        if #available(iOS 10, *) {
            view.addSubview(playerContainer)
        } else {
            view.add(playerContainer)
        }
        playerContainer.translatesAutoresizingMaskIntoConstraints = false
        playerContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        playerContainer.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        playerContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        playerContainer.heightAnchor.constraint(equalToConstant: 68).isActive = true
        if let tabController = tabBarController as? TabBarController {
            miniPlayer = tabController.miniPlayer
            miniPlayer.delegate = self
            embedChild(controller: miniPlayer, in: playerContainer)
            miniPlayer.configure()
        }
    }
    
    func initialize() {
        topView.podcastImageView.image = #imageLiteral(resourceName: "podcast")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        audioPlayer = appDelegate.audioPlayer
        tableView.delegate = self
        DispatchQueue.main.async {
            self.navigationItem.title = self.playlist.name
            guard let playlistEpisodes = self.playlist.playlistEpisodes else { return }
            if playlistEpisodes.count <= 0 {
                self.navigationItem.rightBarButtonItems = []
            } else if playlistEpisodes.count > 0 {
                self.navigationItem.rightBarButtonItems = [UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(self.edit))]
            }
        }
        tableView.isUserInteractionEnabled = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if let browse = self.parent as? PlaylistsViewController {
//            browse.miniPlayer = miniPlayer
//            browse.embedChild(controller: browse.miniPlayer, in: browse.playerContainer)
//            browse.miniPlayer.configure()
        }
    }
    
    @objc private func audioPlayerWillStartPlaying(_ notification: Notification) {
        print(notification)
    }
    
    @objc private func audioPlayerDidStartLoading(_ notification: Notification) {
        print(notification)
    }
    
    
    @objc private func audioPlayerDidStartPlaying(_ notification: Notification) {
        print(notification)
    }
    
    @objc private func audioPlayerDidPause(_ notification: Notification) {
        print(notification)
    }
    
    @objc private func audioPlayerPlaybackTimeChanged(_ notification: Notification) {
        let secondsElapsed = notification.userInfo![AudioPlayerSecondsElapsedUserInfoKey]! as! Double
        let secondsRemaining = notification.userInfo![AudioPlayerSecondsRemainingUserInfoKey]! as! Double
        print(secondsElapsed)
        print(secondsRemaining)
    }
    
    func setupModels() {
        guard let playlistEpisode = playlist.playlistEpisodes else { return }
        for episode in playlistEpisode {
            if let item = episode as? Episode {
                let model = DownloadedCellViewModel(episode: item)
                if let image = UIImage(data: playlist.image as! Data) {
                    model.mainImage = image
                }
                cellModels.append(model)
            }
        }
    }
    
    @objc func edit() {
        mode = mode == .edit ? .add : .edit
        print(mode)
        DispatchQueue.main.async {
            switch self.mode {
            case .edit:
                self.navigationItem.rightBarButtonItems = [UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.edit))]
            case .add:
                self.navigationItem.rightBarButtonItems =  [UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(self.edit))]
            }
            self.tableView.reloadData()
        }
    }
    
    func configureTopView() {
        topView.frame = PodcastListConstants.topFrame
        guard playlist.episodes != nil else { return }
    }
}

extension PlaylistViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let playlist = fetchedResultsController.fetchedObjects?[0], let episodes = playlist.playlistEpisodes {
            return episodes.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DownloadedCell.reuseIdentifier, for: indexPath) as! DownloadedCell
        cell.configureWith(model: cellModels[indexPath.row])
        return cell
    }
}

extension PlaylistViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selectedIndex != nil && selectedIndex != indexPath {
            DispatchQueue.main.async {
                self.cellModels[indexPath.row].currentState = .paused
                self.tableView.reloadRows(at: [self.selectedIndex], with: .fade)
                self.selectedIndex = nil
            }
        } else if selectedIndex != nil && selectedIndex == indexPath {
            DispatchQueue.main.async {
                self.cellModels[self.selectedIndex.row].currentState = .paused
                self.tableView.reloadRows(at: [self.selectedIndex], with: .fade)
            }
        }
        self.selectedIndex = indexPath
        let item = self.playlist.playlistEpisodes?.object(at: indexPath.row) as! Episode
        if let data = item.podcastArtworkImage as? Data, let image = UIImage(data: data), let mediaUrl = item.mediaUrlString {
            miniPlayer.thumbImage.image = image
            guard var episode = item.asEpisodes() else { return }
            miniPlayer.playFor(episode: episode)
            miniPlayer.currentPodcast = episode
            miniPlayer.delegate = self
            if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
               // appDelegate.play(episode: episode)
                self.cellModels[indexPath.row].currentState = .playing
                self.tableView.reloadRows(at: [indexPath], with: .fade)
                self.selectedIndex = indexPath
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return PlaylistViewControllerConstants.rowHeight
    }
}

extension PlaylistViewController: DownloadCellDelegate {
    func playButton(tapped: Bool) {
        print("play")
    }
    
    func pauseButton(tapped: Bool) {
        print("pause")
    }
    
    func moreButtonTapped(sender: Any, cell: DownloadedCell) {
        dump(sender)
        dump(cell)
    }
}

extension PlaylistViewController: MiniPlayerDelegate {
    
    func expandPodcast(episode: Episodes) {
//        if let backingVC = navigationController?.childViewControllers[0] as? BackingViewController {
//            guard let maxiCard = UIStoryboard.init(name: "Player", bundle: nil).instantiateViewController(withIdentifier: "MaxiSongCardViewController") as? CardPlayerViewController else {
//                assertionFailure("No view controller ID MaxiSongCardViewController in storyboard")
//                return
//            }
//            maxiCard.delegate = self
//            maxiCard.backingImage = self.view.makeSnapshot()
//            maxiCard.endBackingImage = self.view.makeEndSnapshot()
//            switch self.miniPlayer.currentState {
//            case .playing:
//                maxiCard.currentState = .playing
//            case .paused:
//                maxiCard.currentState = .paused
//            case .stopped:
//                maxiCard.currentState = .stopped
//            }
//            maxiCard.sourceView = backingVC.miniPlayerViewController
//            maxiCard.backingImage = view.makeSnapshot()
//            maxiCard.currentPodcast = episode
//            if let urlString = URL(string: episode.podcastArtUrlString) {
//                urlString.downloadImage { image in
//                    DispatchQueue.main.async {
//                        maxiCard.coverArtImage.image = image
//                    }
//                }
//            }
//            navigationController?.present(maxiCard, animated: false)
//        }
//        if navigationController?.childViewControllers[0] as? HomeViewController != nil {
//            guard UIStoryboard.init(name: "Player", bundle: nil).instantiateViewController(withIdentifier: "MaxiSongCardViewController") is CardPlayerViewController else {
//                assertionFailure("No view controller ID MaxiSongCardViewController in storyboard")
//                return
//            }
//        }
    }
    
    func expandPodcast(episode: Episode) {
//        guard let maxiCard = UIStoryboard.init(name: "Player", bundle: nil).instantiateViewController(withIdentifier: "MaxiSongCardViewController") as? CardPlayerViewController else {
//            assertionFailure("No view controller ID MaxiSongCardViewController in storyboard")
//            return
//        }
//        DispatchQueue.main.async {
//            maxiCard.delegate = self
//            if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
//                maxiCard.sourceView = self.miniPlayer
//                maxiCard.audioTimeDuration =  appDelegate.audioPlayer.duration
//            }
//            maxiCard.backingImage = self.view.makeSnapshot()
//            maxiCard.endBackingImage = self.view.makeEndSnapshot()
//            switch self.miniPlayer.currentState {
//            case .playing:
//                maxiCard.currentState = .playing
//            case .paused:
//                maxiCard.currentState = .paused
//            case .stopped:
//                maxiCard.currentState = .stopped
//            }
//            maxiCard.currentPodcast = episode.asEpisodes()
//            let title = episode.asEpisodes()?.title
//            maxiCard.currentPodcast?.podcastTitle = title!
//            if let data = episode.podcastArtworkImage, let image = UIImage(data: data as Data) {
//                DispatchQueue.main.async {
//                    maxiCard.coverArtImage.image = image
//                }
//            }
//            self.navigationController?.present(maxiCard, animated: false)
//        }
    }
}

extension PlaylistViewController: CardPlayerViewControllerDelegate {
    func skipButton(tapped: Bool) {
        
    }
    
    func backButton(tapped: Bool) {
        
    }
    
    func dismiss(tapped: Bool) {
        
    }
}

