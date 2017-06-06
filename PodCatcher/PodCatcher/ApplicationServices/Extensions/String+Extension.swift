import Foundation

extension String {
    
    static func constructTimeString(time: Int) -> String {
        
        let minutes = time / 60
        var timeString = String(describing: minutes)
        print(timeString)
        var timerString = ""
        if timeString.characters.count < 2 {
            timerString = "0\(timeString):00"
        } else if timeString.characters.count <= 2 {
            timerString = "\(timeString):00"
        }
        return timerString
    }
    
    // String extension check that itself for valid email pattern and returns boolean
    
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: self)
        return result
    }
}
