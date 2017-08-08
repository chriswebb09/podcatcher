import UIKit
import CoreData
import AVFoundation

private var playlistViewControllerKVOContext = 1

class PlaylistViewController: BaseCollectionViewController {
    
    @objc var player: AudioFilePlayer
    
    var item: CasterSearchResult!
    var items: [PodcastPlaylistItem] = []
    var state: PodcasterControlState = .toCollection
    var selectedIndex: IndexPath!
    var dataSource: BaseMediaControllerDataSource!
    weak var delegate: PlaylistViewControllerDelegate?
    var playlistId: String
    let loadingPop = LoadingPopover()
    var selectedSongIndex: Int!
    var episodes = [Episodes]()
    var mode: PlaylistMode = .list
    var playButtonImage: UIImage!
    var caster = CasterSearchResult()
    var playlistItems = [PodcastPlaylistItem]()
    var bottomMenu = BottomMenu()
    var playlistTitle: String!
    let entryPop = EntryPopover()
    var topView = ListTopView()
    var feedUrl: String!
    var playlistEmptyView: UIView = PlaylistEmptyView()
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
        emptyView.alpha = 0
        edgesForExtendedLayout = []
        collectionView.delegate = self
        view.sendSubview(toBack: background)
        collectionView.register(PodcastPlaylistCell.self)
        collectionView.dataSource = self
        emptyView.frame = UIScreen.main.bounds
        backgroundView.frame = UIScreen.main.bounds
        collectionView.backgroundView = emptyView
        backgroundView.backgroundColor = .white
        for (index, podItem) in (playlist.podcast?.enumerated())! {
            let item = podItem as! PodcastPlaylistItem
            let episode = Episodes(mediaUrlString: item.audioUrl!, audioUrlSting: item.audioUrl!, title: item.episodeTitle!, date: item.stringDate!, description: item.description, duration: item.duration, audioUrlString: item.audioUrl!, stringDuration: "")
            episodes.append(episode)
            playlistItems.append(item)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        collectionView.alpha = 1
        navigationController?.navigationBar.topItem?.title = playlistTitle
        addObserver(self, forKeyPath: #keyPath(PlaylistViewController.player.player.rate), options: [.new, .initial], context: &playlistViewControllerKVOContext)
        addObserver(self, forKeyPath: #keyPath(PlaylistViewController.player.player.currentItem.status), options: [.new, .initial], context: &playlistViewControllerKVOContext)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(false)
        collectionView.alpha = 0
        removeObserver(self, forKeyPath: #keyPath(PlaylistViewController.player.player.rate), context: &playlistViewControllerKVOContext)
        removeObserver(self, forKeyPath: #keyPath(PlaylistViewController.player.player.currentItem.status), context: &playlistViewControllerKVOContext)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == #keyPath(PlayerViewController.player.player.rate) {
            let newRate = (change?[NSKeyValueChangeKey.newKey] as! NSNumber).doubleValue
            DispatchQueue.main.async {
                self.hideLoadingView(loadingPop: self.loadingPop)
            }
            let buttonImageName = newRate == 1.0 ? #imageLiteral(resourceName: "pause-round") : #imageLiteral(resourceName: "play")
            if let index = selectedIndex {
                let cell = collectionView.cellForItem(at: index) as! PodcastPlaylistCell
                DispatchQueue.main.async {
                    cell.playButton.setImage(buttonImageName, for: .normal)
                }
            }
        } else if keyPath == #keyPath(PlayerViewController.player.player.currentItem.status) {
            let newStatus: AVPlayerItemStatus
            if let newStatusAsNumber = change?[NSKeyValueChangeKey.newKey] as? NSNumber {
                guard let status =  AVPlayerItemStatus(rawValue: newStatusAsNumber.intValue) else { return }
                newStatus = status
                print("NEW ITEM \(newStatus.rawValue)")
            } else {
                newStatus = .unknown
            }
            if newStatus == .failed {
                showError(errorString: "Error")
            } else if newStatus == .readyToPlay {
                DispatchQueue.main.async { [weak self] in
                    let buttonImageName = newStatus ==  AVPlayerItemStatus.readyToPlay ? #imageLiteral(resourceName: "pause-round") : #imageLiteral(resourceName: "play")
                    if let index = self?.selectedIndex {
                        guard let strongSelf = self else { return }
                        let cell = strongSelf.collectionView.cellForItem(at: strongSelf.selectedIndex) as! PodcastPlaylistCell
                        DispatchQueue.main.async {
                            cell.playButton.setImage(buttonImageName, for: .normal)
                        }
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
        collectionView.backgroundColor = PodcastListConstants.backgroundColor
    }
    
    func configureTopView() {
        topView.frame = PodcastListConstants.topFrame
        if let item = item, let urlString = item.podcastArtUrlString, let url = URL(string: urlString) {
            topView.podcastImageView.downloadImage(url: url)
        } else {
            topView.podcastImageView.image = #imageLiteral(resourceName: "light-placehoder-2")
        }
        topView.layoutSubviews()
        view.addSubview(topView)
        view.bringSubview(toFront: topView)
        setupView()
    }
    
    func setupView() {
        guard let tabBar = self.tabBarController?.tabBar else { return }
        guard let navHeight = navigationController?.navigationBar.frame.height else { return }
        let viewHeight = (view.bounds.height - navHeight) - 55
        collectionView.frame = CGRect(x: topView.bounds.minX, y: topView.frame.maxY + (tabBar.frame.height + 6), width: view.bounds.width, height: viewHeight - (topView.frame.height - tabBar.frame.height))
        collectionView.backgroundColor = .clear
    }
}


extension PlaylistViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if episodes.count > 0 {
            backgroundView.alpha = 1
            collectionView.backgroundView = backgroundView
        } else if episodes.count <= 1 {
            DispatchQueue.main.async {
                collectionView.backgroundView = self.emptyView
                self.backgroundView.alpha = 0
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
                self.topView.removeFromSuperview()
                self.topView.alpha = 0
                self.collectionView.frame = self.view.bounds
            }
        } else {
            UIView.animate(withDuration: 0.15) {
                guard let tabBar = self.tabBarController?.tabBar else { return }
                guard let navHeight = self.navigationController?.navigationBar.frame.height else { return }
                let viewHeight = (self.view.bounds.height - navHeight) - 20
                self.topView.frame = updatedTopViewFrame
                self.topView.alpha = 1
                self.topView.layoutSubviews()
                self.view.addSubview(self.topView)
                self.collectionView.frame = CGRect(x: self.topView.bounds.minX, y: self.topView.frame.maxY - 5, width: self.view.bounds.width, height: viewHeight - (self.topView.frame.height - tabBar.frame.height))
            }
        }
    }
}

// MARK: - UICollectionViewDelegate

extension PlaylistViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let selectedIndex = selectedIndex {
            if indexPath == selectedIndex {
                player.playPause()
            } else if indexPath != selectedIndex {
                let previousIndex = selectedIndex
                player.playPause()
                let pod = playlistItems[indexPath.row]
                topView.podcastImageView.image = UIImage(data: pod.artwork as! Data)
                let audioUrl = pod.audioUrl
                if let url = URL(string: audioUrl!) {
                    player.asset = AVURLAsset(url: url)
                }
                self.selectedIndex = indexPath
                player.playPause()
                let previousCell = self.collectionView.cellForItem(at: previousIndex) as! PodcastPlaylistCell
                DispatchQueue.main.async {
                    previousCell.playButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
                }
                showLoadingView(loadingPop: loadingPop)
            }
        } else {
            self.selectedIndex = indexPath
            let pod = playlistItems[indexPath.row]
            topView.podcastImageView.image = UIImage(data: pod.artwork as! Data)
            let audioUrl = pod.audioUrl
            if let url = URL(string: audioUrl!) {
                player.asset = AVURLAsset(url: url)
            }
            player.playPause()
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension PlaylistViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width / 1.01, height: UIScreen.main.bounds.height / 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
}

extension PlaylistViewController: TopViewDelegate {
    
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
