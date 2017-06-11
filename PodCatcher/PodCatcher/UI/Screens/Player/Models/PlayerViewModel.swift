import UIKit

class PlayerViewModel {
    let title: String
    var timer: Timer?
    var progressIncrementer: Float = 0
    var time: Int = 0
    var progress: Float = 0
    let imageUrl: UIImage
    
    init(image: UIImage, title: String) {
        self.imageUrl = image
        self.title = title
    }
    
    func switchButtonAlpha(for button: UIButton, withButton: UIButton) {
        button.alpha = 1
        withButton.alpha = 0
    }
    
    func pauseTime(countdict: NSMutableDictionary) {
        if let count = countdict["count"] as? Int {
            countdict["count"] = count
            time = count
            timer?.invalidate()
        }
    }
    
    func reset(playButton: UIButton, pauseButton: UIButton, slider: UISlider) {
        switchButtonAlpha(for: pauseButton, withButton: playButton)
        slider.value = 0
        timer?.invalidate()
    }
}
