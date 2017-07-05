import UIKit
import CoreMedia

// MARK: - PlayerViewDelegate

extension PlayerViewController: PlayerViewDelegate {
    
    func setModel(model: PlayerViewModel) {
        playerView.configure(with: model)
    }
    
    func initPlayer(url: URL)  {
        guard var player = player else { return }
        player = AudioFilePlayer(url: url)
        player.delegate = self
    }
    
    func updateTimeValue(time: Double) {
        guard let player = player else { return }
        player.currentTime = time
        DispatchQueue.main.async {
            let normalizedTime = player.currentTime * 100.0 / player.duration
            let timeString = String.constructTimeString(time: player.currentTime)
            self.playerView.currentPlayTimeLabel.text = timeString
            self.playerView.update(progressBarValue: Float(normalizedTime))
        }
    }
    
    func backButtonTapped() {
        guard index > 0 else { return }
        guard let player = player else { return }
        player.pause()
        index -= 1
        guard let artUrl = caster.podcastArtUrlString else { return }
        showLoadingView(loadingPop: loadingPop)
        if let audioUrl = caster.episodes[index].audioUrlString, let url = URL(string: audioUrl) {
            self.player = AudioFilePlayer(url: url)
            self.initPlayer(url: url)
            DispatchQueue.main.async {
                self.playerViewModel = PlayerViewModel(imageUrl: URL(string: artUrl), title: self.caster.episodes[self.index].title)
                self.setModel(model: self.playerViewModel)
                self.title = self.caster.episodes[self.index].title
            }
        }
        delegate?.skipButton(tapped: true)
    }
    
    func skipButtonTapped() {
        guard index < caster.episodes.count - 1 else { return }
        index += 1
        guard let player = player else { return }
        player.pause()
        guard let artUrl = caster.podcastArtUrlString else { return }
        showLoadingView(loadingPop: loadingPop)
        self.playerViewModel = PlayerViewModel(imageUrl: URL(string: artUrl), title: caster.episodes[index].title)
        self.setModel(model: self.playerViewModel)
        if let audioUrl = caster.episodes[index].audioUrlString, let url = URL(string: audioUrl) {
            self.player = AudioFilePlayer(url: url)
            self.initPlayer(url: url)
            DispatchQueue.main.async {
                self.playerViewModel = PlayerViewModel(imageUrl: URL(string: artUrl), title: self.caster.episodes[self.index].title)
                self.setModel(model: self.playerViewModel)
                self.title = self.caster.episodes[self.index].title
            }
        }
        delegate?.skipButton(tapped: true)
    }
    
    func pauseButtonTapped() {
        guard let player = player else { return }
        player.player.pause()
        delegate?.pauseButton(tapped: true)
        UpdateData.update(Int(player.currentTime))
    }
    
    func playButtonTapped() {
        guard let player = player else { return }
        player.delegate = self
        player.play(player: player.player)
        player.observePlayTime()
        delegate?.playButton(tapped: true)
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
        print("hidePopMenu()")
        bottomMenu.hideFrom(playerView)
    }
    
    func showPopMenu() {
        UIView.animate(withDuration: 0.15) {
            self.bottomMenu.showOn(self.playerView)
        }
    }
}

extension PlayerViewController: AudioFilePlayerDelegate {
    
    func trackFinishedPlaying() {
        print("Finished")
    }
    
    func trackDurationCalculated(stringTime: String, timeValue: Float64) {
        DispatchQueue.main.async {
            self.hideLoadingView(loadingPop: self.loadingPop)
            self.playerView.setPauseButtonAlpha()
            self.playerViewModel.totalTimeString = stringTime
            self.setModel(model: self.playerViewModel)
            self.view.bringSubview(toFront: self.playerView)
        }
    }
    
    func updateProgress(progress: Double) {
        guard let player = player else { return }
        let normalizedTime = player.currentTime * 100.0 / player.duration
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.playerView.currentPlayTimeLabel.text = String.constructTimeString(time: player.currentTime)
            strongSelf.playerView.update(progressBarValue: Float(normalizedTime))
        }
    }
}

extension PlayerViewController: MenuDelegate {
    
    func optionOne(tapped: Bool) {
        guard let player = player else { return }
        switch player.state {
        case .playing:
            pauseButtonTapped()
        default:
            break
        }
        downloadingIndicator.showActivityIndicator(viewController: self)
        if let urlString = caster.episodes[index].audioUrlString {
            let download = Download(url: urlString)
            download.delegate = self
            store.getFile(download)
        }
        hidePopMenu()
    }
    
    func optionTwo(tapped: Bool) {
        print(tapped)
    }
    
    func optionThree(tapped: Bool) {
        print(tapped)
    }
    
    func cancel(tapped: Bool) {
        print("extension cancel(tapped: Bool)")
        hidePopMenu()
    }
    
    func navigateBack(tapped: Bool) {
        delegate?.navigateBack(tapped: tapped)
        navigationController?.popViewController(animated: false)
    }
}


extension PlayerViewController: DownloadDelegate {
    
    func downloadProgressUpdated(for progress: Float) {
        if progress == 1 {
            DispatchQueue.main.async {
                self.downloadingIndicator.hideActivityIndicator(viewController: self)
            }
        }
        print(String(format: "%.1f%%", progress * 100))
    }
}
