import UIKit
import CoreData

extension PlaylistViewController: NSFetchedResultsControllerDelegate {
    
    func setupCoordinator() {
        persistentContainer.loadPersistentStores { persistentStoreDescription, error in
            if let error = error {
                print("Unable to Load Persistent Store - \(error), \(error.localizedDescription)")
            } else {
                do {
                    try self.fetchedResultsController.performFetch()
                } catch let fetchError {
                    print("Unable to Perform Fetch Request - \(fetchError), \(fetchError.localizedDescription)")
                }
            }
        }
    }
}

// MARK: - PodcastCollectionViewProtocol

extension PlaylistViewController: PodcastCollectionViewProtocol {
    
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
}

extension PlaylistViewController: ReloadableCollection {
    
    func setupView() {
        guard let tabBar = self.tabBarController?.tabBar else { return }
        guard let navHeight = navigationController?.navigationBar.frame.height else { return }
        let viewHeight = (view.bounds.height - navHeight) - 55
        collectionView.frame = CGRect(x: topView.bounds.minX, y: topView.frame.maxY + (tabBar.frame.height + 10), width: view.bounds.width, height: viewHeight - (topView.frame.height - tabBar.frame.height))
        collectionView.backgroundColor = .clear
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
                self.collectionView.frame = CGRect(x: self.topView.bounds.minX, y: self.topView.frame.maxY, width: self.view.bounds.width, height: viewHeight - (self.topView.frame.height - tabBar.frame.height))
            }
        }
    }
}

// MARK: - UICollectionViewDelegate

extension PlaylistViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let index = selectedSongIndex {
            let playerIndexPath = IndexPath(item: index, section: 0)
            let cell = collectionView.cellForItem(at: playerIndexPath) as! PodcastPlaylistCell
            if indexPath.row != index {
                cell.switchAlpha(hidden: true)
                player.pause()
            } else if indexPath.row == index {
                switch player.state {
                case .playing:
                    player.pause()
                    let cell = collectionView.cellForItem(at: indexPath) as! PodcastPlaylistCell
                    cell.switchAlpha(hidden: true)
                    player.state = .paused
                case .paused:
                    player.play()
                    let cell = collectionView.cellForItem(at: indexPath) as! PodcastPlaylistCell
                    cell.switchAlpha(hidden: false)
                    player.state = .playing
                case .stopped:
                    break
                }
                return
            }
        }
        guard let items = fetchedResultsController.fetchedObjects else { return }
        guard let audio = items[indexPath.row].audioUrl, let audioUrl = URL(string: audio), let artUrl = items[indexPath.row].artworkUrl, let url = URL(string: artUrl) else { return }
        topView.podcastImageView.downloadImage(url: url)
        player = nil
        self.player = AudioFilePlayer(url: audioUrl)
        self.player.playNext()
        switch player.state {
        case .playing:
            player.pause()
            player.state = .paused
            let cell = collectionView.cellForItem(at: indexPath) as! PodcastPlaylistCell
            cell.switchAlpha(hidden: true)
        case .paused:
            player.play()
            player.state = .playing
            let cell = collectionView.cellForItem(at: indexPath) as! PodcastPlaylistCell
            cell.switchAlpha(hidden: false)
        case .stopped:
            self.player = AudioFilePlayer(url: audioUrl)
            self.player.setUrl(with: audioUrl)
            self.player.delegate = self
            self.player.observePlayTime()
            player.play()
            player.state = .playing
            let cell = collectionView.cellForItem(at: indexPath) as! PodcastPlaylistCell
            cell.switchAlpha(hidden: false)
        }
        selectedSongIndex = indexPath.row
    }
}

// MARK: - UICollectionViewDataSource

extension PlaylistViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as PodcastPlaylistCell
        let item = fetchedResultsController.object(at: indexPath)
        DispatchQueue.main.async {
            if let title = item.episodeTitle, let artist = item.artistName {
                let modelName = "\(title)  -  \(artist)"
                let model = PodcastCellViewModel(podcastTitle: modelName)
                cell.configureCell(model: model)
            }
        }
        return cell
    }
    
    func initPlayer(url: URL?)  {
        guard let url = url else { return }
        player?.setUrl(with: url)
        player?.url = url
        player?.playNext()
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout

extension PlaylistViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return PodcastListViewControllerConstants.size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return PodcastListViewControllerConstants.space
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
        UIView.animate(withDuration: 0.05) {
            self.bottomMenu.showOn(self.collectionView)
        }
    }
    
    func hidePopMenu() {
        print("hidePopMenu")
    }
}

extension PlaylistViewController: AudioFilePlayerDelegate {
    
    func trackFinishedPlaying() {
        print("finished")
    }
    
    func trackDurationCalculated(stringTime: String, timeValue: Float64) {
        print(stringTime)
    }
    
    func updateProgress(progress: Double) {
        print(progress)
    }
}

extension PlaylistViewController: MenuDelegate {
    
    func optionOne(tapped: Bool) {
        
    }
    
    func optionTwo(tapped: Bool) {
        
    }
    
    func optionThree(tapped: Bool) {
        
    }
    
    func cancel(tapped: Bool) {
        
    }
}
