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
        player?.currentTime = time
        guard let duration = player?.duration else { return }
        DispatchQueue.main.async { [weak self] in
            if let currentTime = self?.player?.currentTime {
                let normalizedTime = currentTime * 100.0 / duration
                let timeString = String.constructTimeString(time: currentTime)
                self?.playerView.currentPlayTimeLabel.text = timeString
                self?.playerView.update(progressBarValue: Float(normalizedTime))
            }
        }
    }
    
    func backButtonTapped() {
        guard index > 0 else {
            playerView.enableButtons()
            return
        }
        guard let player = player else { return }
        player.pause()
        index -= 1
        guard let artUrl = caster.podcastArtUrlString else { return }
        showLoadingView(loadingPop: loadingPop)
        if let audioUrl = caster.episodes[index].audioUrlString, let url = URL(string: audioUrl) {
            self.player = nil
            self.player = AudioFilePlayer(url: url)
            self.player?.delegate = self
            self.player?.observePlayTime()
            self.initPlayer(url: url)
            DispatchQueue.main.async { [weak self] in
                if let strongSelf = self {
                    strongSelf.playerViewModel = PlayerViewModel(imageUrl: URL(string: artUrl), title: strongSelf.caster.episodes[strongSelf.index].title)
                    strongSelf.setModel(model: strongSelf.playerViewModel)
                    strongSelf.title = strongSelf.caster.episodes[strongSelf.index].title
                }
            }
        }
        delegate?.skipButton(tapped: true)
    }
    
    
    func skipButtonTapped() {
        guard index < caster.episodes.count - 1 else {
            playerView.enableButtons()
            return
        }
        index += 1
        guard let player = player else { return }
        player.pause()
        guard let artUrl = caster.podcastArtUrlString else { return }
        showLoadingView(loadingPop: loadingPop)
        self.playerViewModel = PlayerViewModel(imageUrl: URL(string: artUrl), title: caster.episodes[index].title)
        self.setModel(model: self.playerViewModel)
        if let audioUrl = caster.episodes[index].audioUrlString, let url = URL(string: audioUrl) {
            self.player = nil
            self.player = AudioFilePlayer(url: url)
            self.player?.delegate = self
            self.player?.observePlayTime()
            self.initPlayer(url: url)
            DispatchQueue.main.async { [weak self] in
                if let strongSelf = self {
                    strongSelf.playerViewModel = PlayerViewModel(imageUrl: URL(string: artUrl), title: strongSelf.caster.episodes[strongSelf.index].title)
                    strongSelf.setModel(model: strongSelf.playerViewModel)
                    strongSelf.title = strongSelf.caster.episodes[strongSelf.index].title
                }
            }
        }
        //        delegate?.skipButton(tapped: true)
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
            print(String.constructTimeString(time: currentTime))
            strongSelf.playerView.currentPlayTimeLabel.text = String.constructTimeString(time: currentTime)
            strongSelf.playerView.update(progressBarValue: Float(normalizedTime))
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
        // None
    }
    
    func optionThree(tapped: Bool) {
        // None
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
