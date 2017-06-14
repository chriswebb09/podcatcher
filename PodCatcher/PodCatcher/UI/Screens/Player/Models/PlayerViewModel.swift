import UIKit

class PlayerViewModel {
    
    let title: String
    var totalTimeString: String?
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
        switchButtonAlpha(for: pauseButton, withButton: playButton)
        slider.value = 0
    }
}
