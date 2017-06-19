import UIKit

class PlayerViewModel {
    
    let title: String
    var totalTimeString: String?
    var currentTimeString: String = "0:00"
    let imageUrl: UIImage
    
    init(image: UIImage, title: String) {
        self.imageUrl = image
        self.title = title
    }
    
    func switchButtonAlpha(for button: UIButton, withButton: UIButton) {
        button.alpha = 1
        withButton.alpha = 0
    }
    
    func reset(playButton: UIButton, pauseButton: UIButton, slider: UISlider) {
        switchButtonAlpha(for: pauseButton, withButton: pauseButton)
        //playButton.alpha = 1
        playButton.alpha = 1 
        slider.value = 0
    }
}
