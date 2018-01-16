import UIKit

struct DownloadState {
    enum State {
        case pausedByUser
        case waitingForConnection
        case inProgress
        case cancelled
        case finished
    }
    
    let url: URL
    var state: State = .pausedByUser
    var progress: Double = 0
}

final class NetworkService: NSObject {
    
    weak var delegate: NetworkServiceDelegate?
    
    var activeDownloads: [String: Download]
    
    lazy var downloadsSession: URLSession = {
        let configuration = URLSessionConfiguration.background(withIdentifier: "background")
        return URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
    }()
    
    override init() {
        self.activeDownloads = [String: Download]()
    }
    
    internal func downloadTrackPreview(for download: Download?) {
        if let download = download, let urlString = download.url, let url = URL(string: urlString) {
            download.downloadTask = downloadsSession.downloadTask(with: url)
            download.downloadTask?.resume()
        }
    }
    
    func startDownload(_ download: Download?) {
        if let newDownload = download, let urlString = newDownload.url {
            activeDownloads[urlString] = newDownload
            downloadTrackPreview(for: download)
        }
    }
}

extension NetworkService: URLSessionDelegate {
    
    internal func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate,
            let completionHandler = appDelegate.backgroundSessionCompletionHandler {
            appDelegate.backgroundSessionCompletionHandler = nil
            DispatchQueue.main.async {
                completionHandler()
            }
        }
    }
    
    internal func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64,totalBytesExpectedToWrite: Int64) {
        if let downloadUrl = downloadTask.originalRequest?.url?.absoluteString {
            let progress =  Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
            delegate?.download(progress: progress)
            if progress == 1 {
                activeDownloads[downloadUrl] = nil
               // session.invalidateAndCancel()
            }
        }
    }
    
    internal func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if let error = error {
            print(error.localizedDescription)
        } else {
            print("The task finished transferring data successfully")
            session.invalidateAndCancel()
        }
    }
}

extension NetworkService: URLSessionDownloadDelegate {
    
    internal func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        guard let sourceURL = downloadTask.originalRequest?.url else { return }
        activeDownloads[sourceURL.absoluteString] = nil
        let destinationURL = LocalStorageManager.localFilePath(for: sourceURL)
        let fileManager = FileManager.default
        try? fileManager.removeItem(at: destinationURL)
        do {
            try fileManager.copyItem(at: location, to: destinationURL)
            print(destinationURL.absoluteString)
            delegate?.download(location: destinationURL.absoluteString)
        } catch let error {
            print("Could not copy file to disk: \(error.localizedDescription)")
        }
    }
}
