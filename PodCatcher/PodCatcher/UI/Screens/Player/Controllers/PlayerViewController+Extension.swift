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
            }
        }
    }
    
    func updateTrack() {
        guard let player = player else { return }
        player.pause()
        guard let artUrl = caster.podcastArtUrlString else { return }
        showLoadingView(loadingPop: loadingPop)
        self.player = nil
        if let urlString = caster.episodes[index].audioUrlString, let url = URL(string: urlString) {
            if  LocalStorageManager.localFileExistsFor(urlString) {
                print("local")
                self.player = AudioFilePlayer(url: url)
                self.player?.delegate = self
                self.player?.observePlayTime()
                self.initPlayer(url: url)
            } else {
                print("non-local")
                self.player = AudioFilePlayer(url: url)
                self.player?.delegate = self
                self.player?.observePlayTime()
                self.initPlayer(url: url)
            }
            DispatchQueue.main.async { [weak self] in
                if let strongSelf = self {
                    strongSelf.playerViewModel = PlayerViewModel(imageUrl: URL(string: artUrl), title: strongSelf.caster.episodes[strongSelf.index].title)
                    strongSelf.setModel(model: strongSelf.playerViewModel)
                    strongSelf.title = strongSelf.caster.episodes[strongSelf.index].title
                }
            }
        }
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
            if let strongSelf = self {
                strongSelf.playerViewModel.totalTimeString = stringTime
                strongSelf.setModel(model: strongSelf.playerViewModel)
                strongSelf.view.bringSubview(toFront: strongSelf.playerView)
                strongSelf.hideLoadingView(loadingPop: strongSelf.loadingPop)
                strongSelf.playerView.enableButtons()
            }
        }
    }
    
    func updateProgress(progress: Double) {
        guard let duration = player?.duration else { return }
        guard let currentTime = player?.currentTime else { return }
        let normalizedTime = currentTime * 100.0 / duration
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.playerView.currentPlayTimeLabel.text = String.constructTimeString(time: currentTime)
            strongSelf.playerView.totalPlayTimeLabel.text = String.constructTimeString(time: (duration - currentTime))
            strongSelf.playerView.update(progressBarValue: Float(normalizedTime))
            if Float(normalizedTime) >= 100 {
                strongSelf.player?.player?.seek(to: kCMTimeZero)
            }
            guard let status = self?.player?.player?.status else { return }
            switch status {
            case .failed:
                print("failed")
                return
            case .unknown:
                print("unknown")
            case .readyToPlay:
                print("ready")
            }
        }
    }
}

extension PlayerViewController: MenuDelegate {
    
    func optionOne(tapped: Bool) {
        DispatchQueue.main.async { [weak self] in
            if let strongSelf = self {
                strongSelf.hideLoadingView(loadingPop: strongSelf.loadingPop)
                strongSelf.delegate?.addItemToPlaylist(item: strongSelf.caster , index: strongSelf.index)
            }
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
        // None
//        let destinationURL = localFilePath(for: sourceURL)
//        let fileManager = FileManager.default
//        try? fileManager.removeItem(at: destinationURL)
    }
    
    func cancel(tapped: Bool) {
        DispatchQueue.main.async { [weak self] in
            if let strongSelf = self {
                strongSelf.hideLoadingView(loadingPop: strongSelf.loadingPop)
                strongSelf.hidePopMenu()
            }
        }
    }
    
    func navigateBack(tapped: Bool) {
        DispatchQueue.main.async { [weak self] in
            if let strongSelf = self {
                strongSelf.hideLoadingView(loadingPop: strongSelf.loadingPop)
                strongSelf.delegate?.navigateBack(tapped: tapped)
                strongSelf.navigationController?.popViewController(animated: false)
            }
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
