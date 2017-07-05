import Foundation

extension String {
    
    static func constructTimeString(time: Double) -> String {
        print("Double \(time)")
        let minutes = Int(time / 60)
        print(time)
        let seconds = Int(time.truncatingRemainder(dividingBy: 60))
        
        print("Seconds \(seconds)")
        var timerString = ""
        if seconds < 10 {
            timerString = "\(minutes):0\(seconds)"
        } else {
            timerString = "\(minutes):\(seconds)"
        }
        print(timerString)
        return timerString
    }
    
    // String extension check that itself for valid email pattern and returns boolean
    
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: self)
        return result
    }
    
    // MARK: - Helpers
    
    static func constructTimeString(time: Int) -> String {
        print(time)
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
            if seconds < 10 {
                timerString = "\(minutes):0\(seconds)"
            } else {
                timerString = "\(minutes):\(seconds)"
            }
        }
        return timerString
    }
    
    static func extract(from link: String) -> String? {
        let pattern = "id([0-9]+)"
        guard let regExp = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive) else {
            return nil
        }
        let nsLink = link as NSString
        let options = NSRegularExpression.MatchingOptions(rawValue: 0)
        let range = NSRange(location: 0, length: nsLink.length)
        let matches = regExp.matches(in: link as String, options:options, range:range)
        if let firstMatch = matches.first {
            return nsLink.substring(with: firstMatch.range)
        }
        return nil
    }
}
