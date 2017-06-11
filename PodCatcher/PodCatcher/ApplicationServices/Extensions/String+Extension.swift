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
}
