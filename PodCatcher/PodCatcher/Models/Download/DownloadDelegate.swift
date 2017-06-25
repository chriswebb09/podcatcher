import UIKit

protocol DownloadDelegate: class {
    func downloadProgressUpdated(for progress: Float)
}
