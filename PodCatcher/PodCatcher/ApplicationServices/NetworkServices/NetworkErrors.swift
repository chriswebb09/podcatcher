import Foundation

enum LoginInError: Error {
    case credentials, network(Error), unknown(URLResponse?)
}

enum RegistrationError: Error {
    case email, network(Error), unknown(URLResponse?)
}
