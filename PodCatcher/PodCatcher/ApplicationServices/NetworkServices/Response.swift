import Foundation

typealias JSON = [String : Any]

enum Response {
    case success(JSON), failed(Error)
}
