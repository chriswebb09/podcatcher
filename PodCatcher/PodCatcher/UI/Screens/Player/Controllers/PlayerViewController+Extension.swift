import UIKit
import CoreMedia
import CoreData
import AVFoundation

// MARK: - PlayerViewDelegate

extension PlayerViewController: PlayerViewDelegate {
    
    func setModel(model: PlayerViewModel) {
        playerView.configure(with: model)
    }
    
    func initPlayer(url: URL?)  {
        guard let url = url else { return }
        player.setUrl(with: url)
        player.url = url
        player.asset = AVURLAsset(url: url)
    }
    
    func updateTimeValue(time: Double) {
        player.currentTime = time
        guard let duration = player.duration else { return }
        DispatchQueue.main.async {
            let normalizedTime = self.player.currentTime * 100.0 / duration
            let timeString = String.constructTimeString(time: self.player.currentTime)
            self.playerView.currentPlayTimeLabel.text = timeString
            self.playerView.update(progressBarValue: Float(normalizedTime))
        }
    }
    
    func backButtonTapped() {
        print(index)
        // showLoadingView(loadingPop: loadingPop)
        guard index > 0 else {
            //  hideLoadingView(loadingPop: loadingPop)
            playerView.enableButtons()
            return
        }
        index -= 1
        player.pause()
        guard let artUrl = caster.podcastArtUrlString else { return }
        
        playerViewModel = PlayerViewModel(imageUrl: URL(string: artUrl), title: episodes[index].title)
        self.setModel(model: self.playerViewModel)
        if let audioUrl = episodes[index].audioUrlString, let url = URL(string: audioUrl) {
            print(audioUrl)
            self.initPlayer(url: url)
            player.playNext()
        }
        playerView.enableButtons()
        delegate?.skipButton(tapped: true)
    }
    
    func skipButtonTapped() {
        
        guard index < episodes.count - 1 else {
            //  hideLoadingView(loadingPop: loadingPop)
            playerView.enableButtons()
            return
        }
        index += 1
        player.pause()
        guard let artUrl = caster.podcastArtUrlString else { return }
        
        playerViewModel = PlayerViewModel(imageUrl: URL(string: artUrl), title: episodes[index].title)
        self.setModel(model: self.playerViewModel)
        if let audioUrl = episodes[index].audioUrlString, let url = URL(string: audioUrl) {
            self.initPlayer(url: url)
            player.playNext()
        }
        playerView.enableButtons()
        delegate?.skipButton(tapped: true)
    }
    
    func pauseButtonTapped() {
        player.pause()
        delegate?.pauseButton(tapped: true)
        UpdateData.update(Int(player.currentTime))
    }
    
    func playButtonTapped() {
        player.play()
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
    
    func loading() {
        DispatchQueue.main.async {
            self.showLoadingView(loadingPop: self.loadingPop)
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
                strongSelf.hideLoadingView(loadingPop: strongSelf.loadingPop)
                strongSelf.playerView.setPauseButtonAlpha()
                strongSelf.playerViewModel.totalTimeString = stringTime
                strongSelf.setModel(model: strongSelf.playerViewModel)
                strongSelf.view.bringSubview(toFront: strongSelf.playerView)
            }
        }
    }
    
    func updateProgress(progress: Double) {
        guard let duration = player.duration else { return }
        let normalizedTime = player.currentTime * 100.0 / duration
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            print(String.constructTimeString(time: strongSelf.player.currentTime))
            strongSelf.playerView.currentPlayTimeLabel.text = String.constructTimeString(time: strongSelf.player.currentTime)
            strongSelf.playerView.update(progressBarValue: Float(normalizedTime))
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
        
    }
    
    func optionThree(tapped: Bool) {
        
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
