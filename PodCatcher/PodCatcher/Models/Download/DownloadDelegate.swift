import UIKit

protocol DownloadDelegate: class {
    func download(progress updated: Float)
    func download(location set: String) 
}
