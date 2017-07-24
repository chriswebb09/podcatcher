import UIKit
import CoreMedia
import CoreData
import AVFoundation

// MARK: - PlayerViewDelegate

extension PlayerViewController: PlayerViewDelegate {
    
    func setModel(model: PlayerViewModel?) {
        if let model = model {
            playerView.configure(with: model)
        }
    }
    
    func initPlayer(url: URL?)  {
        guard let url = url else { return }
        player?.setUrl(with: url)
        player?.url = url
        player?.playNext()
    }
    
    func updateTimeValue(time: Double) {
        guard let duration = player?.duration else { return }
        player?.currentTime = (time * duration) / 100
        DispatchQueue.main.async { [weak self] in
            if let strongSelf = self, let player = strongSelf.player {
                let timeString = String.constructTimeString(time: player.currentTime)
                strongSelf.playerView.currentPlayTimeLabel.text = timeString
                strongSelf.player?.play()
            }
        }
    }
    
    func loadAudioFile() {
        if let urlString = caster.episodes[index].audioUrlString, let url = URL(string: urlString) {
            self.player = AudioFilePlayer(url: url)
            self.player?.delegate = self
            self.player?.observePlayTime()
            self.initPlayer(url: url)
            if  LocalStorageManager.localFileExistsFor(urlString) {
                print("local")
            } else {
                print("non-local")
            }
        }
    }
    
    func updatePlayerViewModel() {
        guard let artUrl = caster.podcastArtUrlString else { return }
        DispatchQueue.main.async { [weak self] in
            if let strongSelf = self {
                strongSelf.playerViewModel = PlayerViewModel(imageUrl: URL(string: artUrl), title: strongSelf.caster.episodes[strongSelf.index].title)
                strongSelf.setModel(model: strongSelf.playerViewModel)
                strongSelf.title = strongSelf.caster.episodes[strongSelf.index].title
            }
        }
    }
    
    func updateTrack() {
        guard let player = player else { return }
        player.pause()
        showLoadingView(loadingPop: loadingPop)
        self.player = nil
        loadAudioFile()
        updatePlayerViewModel()
    }
    
    func backButtonTapped() {
        guard index > 0 else {
            playerView.enableButtons()
            return
        }
        index -= 1
        updateTrack()
    }
    
    func skipButtonTapped() {
        guard index < caster.episodes.count - 1 else {
            playerView.enableButtons()
            return
        }
        index += 1
        updateTrack()
    }
    
    func pauseButtonTapped() {
        player?.pause()
    }
    
    func playButtonTapped() {
        player?.play()
    }
    
    func moreButton(tapped: Bool) {
        let height = view.bounds.height * 0.5
        let width = view.bounds.width
        let size = CGSize(width: width, height: height)
        let originX = view.bounds.width * 0.001
        let originY = view.bounds.height * 0.6
        let origin = CGPoint(x: originX, y: originY)
        bottomMenu.menu.delegate = self
        bottomMenu.setMenu(size)
        bottomMenu.setMenu(origin)
        bottomMenu.setupMenu()
        bottomMenu.setMenu(color: .white, borderColor: .darkGray, textColor: .darkGray)
        showPopMenu()
    }
    
    func hidePopMenu() {
        bottomMenu.hideFrom(playerView)
    }
    
    func showPopMenu() {
        UIView.animate(withDuration: 0.05) {
            self.bottomMenu.showOn(self.playerView)
        }
    }
}

extension PlayerViewController: AudioFilePlayerDelegate {
    
    func trackFinishedPlaying() {
        print("Finished")
    }
    
    func trackDurationCalculated(stringTime: String, timeValue: Float64) {
        print(stringTime)
        DispatchQueue.main.async { [weak self] in
            guard let loadingPop = self?.loadingPop, let playerView = self?.playerView else { return }
            self?.playerViewModel.totalTimeString = stringTime
            self?.setModel(model: self?.playerViewModel)
            self?.view.bringSubview(toFront: playerView)
            self?.hideLoadingView(loadingPop: loadingPop)
            self?.playerView.enableButtons()
        }
    }
    
    func updateProgress(progress: Double) {
        guard let duration = player?.duration else { return }
        guard let currentTime = player?.currentTime else { return }
        if currentTime > 0 && duration > 0 {
            let normalizedTime = currentTime * 100.0 / duration
            DispatchQueue.main.async { [weak self] in
                self?.playerView.currentPlayTimeLabel.text = String.constructTimeString(time: currentTime)
                self?.playerView.totalPlayTimeLabel.text = String.constructTimeString(time: (duration - currentTime))
                self?.playerView.update(progressBarValue: Float(normalizedTime))
                if normalizedTime >= 100 {
                    self?.player?.player?.seek(to: kCMTimeZero)
                }
            }
        }
    }
}

extension PlayerViewController: MenuDelegate {
    
    func optionOne(tapped: Bool) {
        DispatchQueue.main.async { [weak self] in
            guard let loadingPop = self?.loadingPop, let caster = self?.caster, let index = self?.index else { return }
            self?.hideLoadingView(loadingPop: loadingPop)
            self?.delegate?.addItemToPlaylist(item: caster , index: index)
        }
    }
    
    func optionTwo(tapped: Bool) {
        if let urlString = caster.episodes[index].audioUrlString, !LocalStorageManager.localFileExistsFor(urlString) {
            downloadingIndicator.showActivityIndicator(viewController: self)
            let download = Download(url: urlString)
            network.startDownload(download)
        }
        hidePopMenu()
    }
    
    func optionThree(tapped: Bool) {
        
    }
    
    func cancel(tapped: Bool) {
        DispatchQueue.main.async { [weak self] in
            guard let loadingPop = self?.loadingPop else { return }
            self?.hideLoadingView(loadingPop: loadingPop)
            self?.hidePopMenu()
        }
    }
    
    func navigateBack(tapped: Bool) {
        DispatchQueue.main.async { [weak self] in
            guard let loadingPop = self?.loadingPop else { return }
            self?.hideLoadingView(loadingPop: loadingPop)
            self?.delegate?.navigateBack(tapped: tapped)
            self?.navigationController?.popViewController(animated: false)
        }
    }
}

extension PlayerViewController: DownloadServiceDelegate {
    
    func download(location set: String) {
        player = nil
        if let url = URL(string: set) {
            player = AudioFilePlayer(url: url)
            player?.delegate = self
            player?.observePlayTime()
            initPlayer(url: url)
        }
    }
    
    func download(progress updated: Float) {
        if updated == 1 {
            DispatchQueue.main.async { [weak self] in
                if let strongSelf = self {
                    UIView.animate(withDuration: 0.5) {
                        strongSelf.downloadingIndicator.hideActivityIndicator(viewController: strongSelf)
                    }
                }
            }
        }
        print(String(format: "%.1f%%", updated * 100))
    }
}
