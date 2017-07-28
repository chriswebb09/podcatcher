import Foundation

protocol NetworkServiceDelegate: class {
    func download(progress updated: Float)
    func download(location set: String)
}
