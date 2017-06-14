import UIKit

class PlayerViewModel {
    
    let title: String
    var timer: Timer?
    var progressIncrementer: Float = 0

    var playTimeIncrement: Float = 0.1
    var time: Int = 0
    var totalTimeString: String?
    
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
    
    func constructTimeString(time: Int) -> String {
        var timeString = String(describing: time)
        var timerString = ""
        if timeString.characters.count < 2 {
            timerString = "0:0\(timeString)"
        } else if timeString.characters.count == 2 {
            timerString = "0:\(timeString)"
        }
        if time >= 60 {
            print(time)
            let minutes = time / 60
            let seconds = time % 10
            timerString = "\(minutes):0\(seconds)"
        }
        
        return timerString
    }

}
