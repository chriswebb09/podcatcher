import UIKit

final class PlayerViewModel {
    var state: PlayerState  = .paused
    let title: String
    var totalTimeString: String?
    var currentTimeString: String = "0:00"
    
   // var controlButtonImage: UIImage {
//        switch self.state {
//        case .paused:
//            print("paused")
//            return #imageLiteral(resourceName: "play-icon")
//        case .playing:
//            print("playing")
//            return #imageLiteral(resourceName: "white-bordered-pause")
//        case .stopped:
//            print("stopped")
//            return #imageLiteral(resourceName: "play-icon")
//        default:
//            print("default")
//            return #imageLiteral(resourceName: "white-bordered-pause")
//        }
//    }
    
    let imageUrl: URL?
    
    init(imageUrl: URL?, title: String) {
        self.imageUrl = imageUrl
        self.title = title
    }
    
    func switchButtonAlpha(for button: UIButton, withButton: UIButton) {
        button.alpha = 1
        withButton.alpha = 0
    }
    
    func reset(playButton: UIButton, pauseButton: UIButton, slider: UISlider) {
        switchButtonAlpha(for: pauseButton, withButton: pauseButton)
        playButton.alpha = 1
        slider.value = 0
    }
    
//    func setControlButton(button: UIButton) {
//        button.setImage(controlButtonImage, for: .normal)
//    }
}
