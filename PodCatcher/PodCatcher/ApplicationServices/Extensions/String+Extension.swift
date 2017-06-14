import Foundation

extension String {
    
    static func constructTimeString(time: Double) -> String {
        let minutes = Int(time / 60)
        let seconds = Int(time.truncatingRemainder(dividingBy: 60))
        return  "\(minutes):\(seconds)"
    }
    
    // String extension check that itself for valid email pattern and returns boolean
    
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: self)
        return result
    }
    
//    func reset(playButton: UIButton, pauseButton: UIButton, slider: UISlider) {
//        switchButtonAlpha(for: pauseButton, withButton: playButton)
//        slider.value = 0
//        
//    }
    
    static func constructTimeString(time: Int) -> String {
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
