import UIKit
import CoreData
import AVFoundation

private var playlistViewControllerKVOContext = 1

class PlaylistViewController: BaseCollectionViewController, ErrorPresenting, LoadingPresenting {
    
    @objc var player: AudioFilePlayer?
    
    var item: CasterSearchResult!
    var items: [PodcastPlaylistItem] = []
    var state: PodcasterControlState = .toCollection
    var selectedIndex: IndexPath!
    var dataSource: BaseMediaControllerDataSource!
    weak var delegate: PlaylistViewControllerDelegate?
    var playlistId: String
    let loadingPop = LoadingPopover()
    var selectedSongIndex: Int!
    var episodes = [Episode]()
    var mode: PlaylistMode = .list
    var playButtonImage: UIImage!
    var caster = CasterSearchResult()
    var playlistItems = [PodcastPlaylistItem]()
    var bottomMenu = BottomMenu()
    var playlistTitle: String!
    let entryPop = EntryPopover()
    var topView = ListTopView()
    var itemMode: PlaylistItemMode = .play
    var feedUrl: String!
    var playlistEmptyView: UIView = InformationView(data: "Create playlists with your favorite episodes", icon: #imageLiteral(resourceName: "podcast-icon-1"))
    var backgroundView = UIView()
    let playlist: PodcastPlaylist!
    
    init(index: Int, player: AudioFilePlayer, playlist: PodcastPlaylist) {
        self.playlistId = ""
        self.playlistTitle = ""
        self.player = AudioFilePlayer()
        self.playlist = playlist
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topView.delegate = self
        configureTopView()
        background.frame = view.frame
        view.addSubview(background)
        emptyView = InformationView(data: "Add Podcasts", icon: #imageLiteral(resourceName: "list"))
        emptyView.alpha = 0
        edgesForExtendedLayout = []
        collectionView.delegate = self
        view.sendSubview(toBack: background)
        collectionView.register(PodcastPlaylistCell.self)
        collectionView.dataSource = self
        emptyView.frame = UIScreen.main.bounds
        
        collectionView.backgroundView = emptyView

        guard let podcast = playlist.podcast else { return }
        
        for (_, podItem) in podcast.enumerated() {
            let item = podItem as! PodcastPlaylistItem
            dump(item)
            if let audio = item.audioUrl, let title = item.episodeTitle, let podcaster = item.artistName, let date = item.stringDate {
                let duration = item.duration
                let description = item.description
                let episode = Episode(mediaUrlString: audio,
                                       audioUrlSting: audio,
                                       title: title,
                                       podcastTitle: podcaster,
                                       date: date,
                                       description: description,
                                       duration: duration,
                                       audioUrlString: audio,
                                       stringDuration: "",
                                       tags: [])
                episodes.append(episode)
                playlistItems.append(item)
            }
        }
        DispatchQueue.main.async {
            self.topView.podcastImageView.layer.cornerRadius = 4
            self.topView.podcastImageView.layer.masksToBounds = true
            self.topView.layer.setCellShadow(contentView: self.topView)
            self.topView.podcastImageView.layer.setCellShadow(contentView: self.topView.podcastImageView)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        collectionView.alpha = 1
        addObserver(self, forKeyPath: #keyPath(PlaylistViewController.player.player.rate), options: [.new, .initial], context: &playlistViewControllerKVOContext)
        addObserver(self, forKeyPath: #keyPath(PlaylistViewController.player.player.currentItem.status), options: [.new, .initial], context: &playlistViewControllerKVOContext)
        self.topView.podcastImageView.layer.setCellShadow(contentView: self.topView.podcastImageView)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(false)
        collectionView.alpha = 0
        removeObserver(self, forKeyPath: #keyPath(PlaylistViewController.player.player.rate), context: &playlistViewControllerKVOContext)
        removeObserver(self, forKeyPath: #keyPath(PlaylistViewController.player.player.currentItem.status), context: &playlistViewControllerKVOContext)
        self.player = nil
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == #keyPath(PlayerViewController.player.player.rate) {
            let newRate = (change?[NSKeyValueChangeKey.newKey] as! NSNumber).doubleValue
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else { return }
                let cellState = newRate == 1.0 ? PodcastPlaylistCell.CellState.playing : PodcastPlaylistCell.CellState.paused
                if let index = strongSelf.selectedIndex, let cell = strongSelf.collectionView.cellForItem(at: index) as? PodcastPlaylistCell {
                    cell.currentState = cellState
                }
            }
        } else if keyPath == #keyPath(PlayerViewController.player.player.currentItem.status) {
            let newStatus: AVPlayerItemStatus
            if let newStatusAsNumber = change?[NSKeyValueChangeKey.newKey] as? NSNumber {
                guard let status =  AVPlayerItemStatus(rawValue: newStatusAsNumber.intValue) else { return }
                newStatus = status
                if newStatus.rawValue == 1 {
                    DispatchQueue.main.async { [weak self] in
                        guard let strongSelf = self else { return }
                        strongSelf.hideLoadingView(loadingPop: strongSelf.loadingPop)
                    }
                }
            } else {
                newStatus = .unknown
            }
            if newStatus == .failed {
                presentError(title: "Error", message: "Error")
            } else if newStatus == .readyToPlay {
                DispatchQueue.main.async { [weak self] in
                    guard let strongSelf = self else { return }
                    let buttonImageName = newStatus ==  AVPlayerItemStatus.readyToPlay ? #imageLiteral(resourceName: "pause-round") : #imageLiteral(resourceName: "play")
                    if let cell = strongSelf.collectionView.cellForItem(at: strongSelf.selectedIndex) as? PodcastPlaylistCell {
                        cell.playButton.setImage(buttonImageName, for: .normal)
                    }
                }
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        switch state {
        case .toCollection:
            navigationController?.popViewController(animated: false)
        case .toPlayer:
            break
        }
    }
    
    func moreButton(tapped: Bool) {
        let height = view.bounds.height * 0.5
        let width = view.bounds.width
        let size = CGSize(width: width, height: height)
        let originX = view.bounds.width * 0.001
        let originY = view.bounds.height * 0.6
        let origin = CGPoint(x: originX, y: originY)
        bottomMenu.setMenu(size)
        bottomMenu.setMenu(origin)
        bottomMenu.setupMenu()
        bottomMenu.setMenu(color: .white, borderColor: .darkGray, textColor: .darkGray)
        showPopMenu()
    }
}

// MARK: - PodcastCollectionViewProtocol

extension PlaylistViewController {
    
    func setup(dataSource: UICollectionViewDataSource, delegate: UICollectionViewDelegate) {
        collectionView.dataSource = dataSource
        collectionView.delegate = delegate
        collectionView.register(PodcastCell.self)
//        let newView = UIView()
//        newView.frame = collectionView.frame
//        collectionView.add(newView)
        collectionView.backgroundColor = .white
            //PodcastListConstants.backgroundColor
    }
    
    func configureTopView() {
        topView.frame = PodcastListConstants.topFrame
        guard let podcast = playlist.podcast else { return }
        
        for (index, podItem) in podcast.enumerated() {
            if index == 0 {
                if let item = podItem as? PodcastPlaylistItem, let id = item.playlistId {
                    self.title = id
                }
            }
            if let item = podItem as? PodcastPlaylistItem, let topImageArtworkData = item.artwork,
                let artworkImage = UIImage(data: Data.init(referencing: topImageArtworkData)) {
                topView.podcastImageView.image = artworkImage
            } else {
                topView.podcastImageView.image = #imageLiteral(resourceName: "light-placehoder-2")
            }
        }
        if topView.podcastImageView.image == nil {
            topView.podcastImageView.image = #imageLiteral(resourceName: "light-placehoder-2")
        }
        topView.layoutSubviews()
        view.addSubview(topView)
        view.bringSubview(toFront: topView)
        
        setupView()
        dump(collectionView)
    }
    
    func setupView() {
        guard let tabBar = self.tabBarController?.tabBar else { return }
        guard let navHeight = navigationController?.navigationBar.frame.height else { return }
        let viewHeight = (view.bounds.height - navHeight) - 55
        collectionView.frame = CGRect(x: topView.bounds.minX, y: topView.frame.maxY + (tabBar.frame.height + 6), width: view.bounds.width, height: viewHeight - (topView.frame.height - tabBar.frame.height))
        collectionView.backgroundColor = .white
    }
}


extension PlaylistViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if episodes.count > 0 {
            backgroundView.alpha = 1
            collectionView.backgroundView = backgroundView
        } else if episodes.count <= 1 {
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else { return }
                collectionView.backgroundView = strongSelf.emptyView
                strongSelf.backgroundView.alpha = 0
            }
        }
        return episodes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as PodcastPlaylistCell
        let modelName = "\(playlistItems[indexPath.row].artistName!)  -  \(playlistItems[indexPath.row].episodeTitle!)"
        let model = PodcastCellViewModel(podcastTitle: modelName)
        cell.configureCell(model: model)
        return cell
    }
}
// MARK: - UIScrollViewDelegate

extension PlaylistViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset
        let updatedTopViewFrame = CGRect(x: 0, y: 0, width: PodcastListConstants.topFrameWidth, height: PodcastListConstants.topFrameHeight / 1.2)
        if offset.y > PodcastListConstants.minimumOffset {
            UIView.animate(withDuration: 0.05) {
                DispatchQueue.main.async { [weak self] in
                    guard let strongSelf = self else { return }
                    strongSelf.topView.removeFromSuperview()
                    strongSelf.topView.alpha = 0
                    strongSelf.collectionView.frame = strongSelf.view.bounds
                }
            }
        } else {
            UIView.animate(withDuration: 0.15) {
                DispatchQueue.main.async { [weak self] in
                    guard let strongSelf = self else { return }
                    guard let tabBar = strongSelf.tabBarController?.tabBar else { return }
                    guard let navHeight = strongSelf.navigationController?.navigationBar.frame.height else { return }
                    let viewHeight = (strongSelf.view.bounds.height - navHeight) - 20
                    strongSelf.topView.frame = updatedTopViewFrame
                    strongSelf.topView.alpha = 1
                    strongSelf.topView.layoutSubviews()
                    strongSelf.view.addSubview(strongSelf.topView)
                    strongSelf.collectionView.frame = CGRect(x: strongSelf.topView.bounds.minX, y: strongSelf.topView.frame.maxY - 5, width: strongSelf.view.bounds.width, height: viewHeight - (strongSelf.topView.frame.height - tabBar.frame.height))
                }
            }
        }
    }
}

// MARK: - UICollectionViewDelegate

extension PlaylistViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch itemMode {
        case .play:
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.showLoadingView(loadingPop: strongSelf.loadingPop)
            }
            if let selectedIndex = selectedIndex {
                if indexPath == selectedIndex {
                    player?.playPause()
                    DispatchQueue.main.async { [weak self] in
                        guard let strongSelf = self else { return }
                        strongSelf.hideLoadingView(loadingPop: strongSelf.loadingPop)
                    }
                } else if indexPath != selectedIndex {
                    var previousIndex: IndexPath? = selectedIndex
                    player?.playPause()
                    let pod = playlistItems[indexPath.row]
                    if let artWorkImageData = pod.artwork,
                        let artworkImage = UIImage(data: Data.init(referencing: artWorkImageData)),
                        let audioUrl = pod.audioUrl, let url = URL(string: audioUrl) {
                        topView.podcastImageView.image = artworkImage
                        if LocalStorageManager.localFileExists(for: url.absoluteString) {
                            print("file is downloaded")
                            let newUrl = LocalStorageManager.localFilePath(for: url)
                            player?.asset = AVURLAsset(url: newUrl)
                        } else {
                            print("streaming")
                            player?.asset = AVURLAsset(url: url)
                        }
                        DispatchQueue.main.async { [weak self] in
                            guard let strongSelf = self else { return }
                            if let previousIndex = previousIndex,
                                let previousCell = strongSelf.collectionView.cellForItem(at: previousIndex) as? PodcastPlaylistCell {
                                previousCell.playButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
                            }
                        }
                    }
                    previousIndex = nil
                    self.selectedIndex = indexPath
                }
            } else {
                let pod = playlistItems[indexPath.row]
                let audioUrl = pod.audioUrl
                if let artWorkImageData = pod.artwork,
                    let artworkImage = UIImage(data: Data.init(referencing: artWorkImageData)),
                    let url = URL(string: audioUrl!) {
                    if LocalStorageManager.localFileExists(for: url.absoluteString) {
                        print("file is downloaded")
                        let newUrl = LocalStorageManager.localFilePath(for: url)
                        player?.asset = AVURLAsset(url: newUrl)
                    } else {
                        print("streaming")
                        player?.asset = AVURLAsset(url: url)
                    }
                    topView.podcastImageView.image = artworkImage
                }
                self.selectedIndex = indexPath
                player?.playPause()
            }
        case .delete:
            print("delete")
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension PlaylistViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width / 1.0, height: UIScreen.main.bounds.height / 11)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
}

extension PlaylistViewController: TopViewDelegate {
    
    func infoButton(tapped: Bool) {
        print(item.tags)
    }
    
    
    func entryPop(popped: Bool) {
        print("popped: \(popped)")
    }
    
    func popBottomMenu(popped: Bool) {
        showPopMenu()
    }
    
    func showPopMenu() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(hidePopMenu))
        view.addGestureRecognizer(tap)
        collectionView.addGestureRecognizer(tap)
        topView.addGestureRecognizer(tap)
        bottomMenu.showOn(collectionView)
    }
    
    @objc func hidePopMenu() {
        print("hidePopMenu")
    }
}
