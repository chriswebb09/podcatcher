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
       // player.player.pause()
        index -= 1
        guard let url = caster.assets[index].audioUrl else { return }
        
        guard let artwork = caster.artwork else { return }
        self.playerViewModel = PlayerViewModel(image: artwork, title: caster.assets[index].title)
        setModel(model: PlayerViewModel(image: artwork, title: caster.assets[index].title))
        initPlayer(url: url)
      //  player.player.play()
        delegate?.skipButtonTapped()
    }
    
    func skipButtonTapped() {
        guard index < caster.assets.count - 1 else { return }
        guard let player = player else { return }
     //   player.player.pause()
        player.pause()
        index += 1
        guard let url = caster.assets[index].audioUrl else { return }
        
        guard let artwork = caster.artwork else { return }
        self.playerViewModel = PlayerViewModel(image: artwork, title: caster.assets[index].title)
        setModel(model: PlayerViewModel(image: artwork, title: caster.assets[index].title))
        initPlayer(url: url)
       // player.player.play()
        delegate?.skipButtonTapped()
    }
    
    func pauseButtonTapped() {
        guard let player = player else { return }
        player.player.pause()
        delegate?.pauseButtonTapped()
        UpdateData.update(Int(player.currentTime))
    }
    
    func playButtonTapped() {
        guard let player = player else { return }
        player.delegate = self
        player.play(player: player.player)
        player.observePlayTime()
        delegate?.playButtonTapped()
    }
}

extension PlayerViewController: AudioFilePlayerDelegate {
    
    func trackFinishedPlaying() {
        print("Finished")
    }
    
    func trackDurationCalculated(stringTime: String, timeValue: Float64) {
        DispatchQueue.main.async {
            self.playerViewModel.totalTimeString = stringTime
            self.setModel(model: self.playerViewModel)
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
