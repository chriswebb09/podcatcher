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

import Foundation

struct Resource<A> {
    var method: String = "GET"
    var body: Data? = nil
    let url: URL
}

extension Resource {
    var request: URLRequest {
        var result = URLRequest(url: url)
        result.httpMethod = method
        return result
    }
}

extension URLSession {
    @discardableResult func load(_ request: URLRequest, completion: @escaping (Response) -> Void) -> URLSessionDataTask {
        let task = dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let e = error {
                    completion(.failed(e))
                } else if let d = data {
                    guard let responseObject = try? JSONSerialization.jsonObject(with: d, options: .allowFragments) as? JSON else { return }
                    DispatchQueue.main.async {
                        completion(.success(responseObject))
                    }
                }
            }
        }
        task.resume()
        return task
        
    }
}


final class NetworkService: NSObject {
    
    //    weak var delegate: NetworkServiceDelegate?
    //
    //    var activeDownloads: [String: Download]
    //
    //    lazy var downloadsSession: URLSession = {
    //        let configuration = URLSessionConfiguration.background(withIdentifier: "background")
    //        return URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
    //    }()
    //
    override init() {
        self.activeDownloads = [String: Download]()
    }
    
    
    weak var delegate: NetworkServiceDelegate?
    
    var activeDownloads: [String: Download]
    
    lazy var downloadsSession: URLSession = {
        let configuration = URLSessionConfiguration.background(withIdentifier: "background")
        return URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
    }()
    
    //    override init() {
    //        self.activeDownloads = [String: Download]()
    //    }
    
    static func search(for query: String, _ completion: @escaping (Response) -> Void) {
        guard let url = build(searchTerm: query) else { return }
        let session =  URLSession(configuration: .ephemeral)
        let request = URLRequest(url: url)
        session.load(request) { response in
            completion(response)
        }
    }
    
    static func search(forLookup: String?, completion: @escaping (Response) -> Void) {
        guard let forLookup = forLookup else { return }
        guard let url = URL(string: "https://itunes.apple.com/lookup?id=\(forLookup)&entity=podcast&limit=15") else { return }
        let request = URLRequest(url: url)
        let session = URLSession(configuration: .ephemeral)
        session.load(request) { response in
            completion(response)
        }
    }
    
    static func build(searchTerm: String) -> URL? {
        guard let encodedQuery = searchTerm.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return nil }
        let urlString = URLRouter.base.url + URLRouter.path.url + encodedQuery
        print(urlString)
        return URL(string: urlString)
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
