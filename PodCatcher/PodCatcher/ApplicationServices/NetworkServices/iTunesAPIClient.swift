import UIKit

typealias JSON = [String : Any]

enum Response {
    case success(JSON?), failed(Error)
}

enum URLRouter {
    
    case base, path
    
    var url: String {
        switch self {
        case .base:
            return "https://itunes.apple.com"
        case .path:
            return "/search?country=US&media=podcast&limit=15&term="
            
        }
    }
}

final class iTunesAPIClient {
    
    static func search(for query: String, _ completion: @escaping (Response) -> Void) {
        guard let url = build(searchTerm: query) else { return }
        URLSession(configuration: .ephemeral).dataTask(with: URLRequest(url: url)) { data, response, error in
            if let error = error {
                completion(.failed(error))
            } else {
                do {
                    guard let data = data else { return }
                    guard let responseObject = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? JSON else { return }
                    DispatchQueue.main.async {
                        completion(.success(responseObject))
                    }
                }
            }}.resume()
    }
    
    static func search(forLookup: String?, completion: @escaping (Response) -> Void) {
        guard let forLookup = forLookup else { return }
        guard let url = URL(string: "https://itunes.apple.com/lookup?id=\(forLookup)&entity=podcast&limit=15") else { return }
        URLSession(configuration: .ephemeral).dataTask(with: URLRequest(url: url)) { data, response, error in
            if let error = error {
                completion(.failed(error))
            } else {
                do {
                    guard let data = data else { return }
                    guard let responseObject = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? JSON else { return }
                    DispatchQueue.main.async {
                        completion(.success(responseObject))
                    }
                }
            }}.resume()
    }
    
    static func build(searchTerm: String) -> URL? {
        guard let encodedQuery = searchTerm.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return nil }
        let urlString = URLRouter.base.url + URLRouter.path.url + encodedQuery
        print(urlString)
        return URL(string: urlString)
    }
}
//
//struct SearchResultsIteractor {
//    
//    var searchTerm: String? = ""
//    var lookup: String? = ""
//    
//    mutating func setSearch(term: String?) {
//        searchTerm = term
//    }
//    
//    mutating func setLookup(term: String?) {
//        lookup = term
//    }
//    
//    func searchForTracksFromLookup(completion: @escaping (_ results: [JSON?]? , _ error: Error?) -> Void) {
//        iTunesAPIClient.search(forLookup: lookup) { response in
//            switch response {
//            case .success(let data):
//                guard let data = data else { return }
//                let resultsData = data["results"] as? [[String: Any]?]?
//                DispatchQueue.main.async {
//                    guard let resultsData = resultsData else { return }
//                    completion(resultsData, nil)
//                }
//            case .failed(let error):
//                completion(nil, error)
//            }
//        }
//    }
//    
//    func searchForTracks(completion: @escaping (_ results: [PodcastItem?]? , _ error: Error?) -> Void) {
//        guard let searchTerm = searchTerm else { return }
//        iTunesAPIClient.search(for: searchTerm) { response in
//            switch response {
//            case .success(let data):
//                guard let data = data else { return }
//                let resultsData = data["results"] as? [[String: Any]?]?
//                if let resultsData = resultsData {
//                    var results = [PodcastItem]()
//                    resultsData?.forEach { resultingData in
//                        guard let resultingData = resultingData else { return }
//                        if let caster = PodcastItem(json: resultingData) {
//                            results.append(caster)
//                        }
//                    }
//                    DispatchQueue.main.async {
//                        completion(results, nil)
//                    }
//                }
//            case .failed(let error):
//                completion(nil, error)
//            }
//        }
//    }
//}

//class WebDataCache {
//
//    static let imageCache: NSCache<NSString, UIImage> = {
//        var cache = NSCache<NSString, UIImage>()
//        cache.name = "ImageCache"
//        cache.countLimit = 4
//        cache.totalCostLimit = 10 * 1024 * 1024
//        return cache
//    }()
//}
//



//struct DownloadState {
//    enum State {
//        case pausedByUser
//        case waitingForConnection
//        case inProgress
//        case cancelled
//        case finished
//    }
//
//    let url: URL
//    var state: State = .pausedByUser
//    var progress: Double = 0
//}


//import UIKit
//
//typealias JSON = [String : Any]
//
//final class NetworkService: NSObject {
//
//    weak var delegate: NetworkServiceDelegate?
//
//    var activeDownloads: [String: Download]
//
//    lazy var downloadsSession: URLSession = {
//        let configuration = URLSessionConfiguration.background(withIdentifier: "background")
//        return URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
//    }()
//
//    override init() {
//        self.activeDownloads = [String: Download]()
//    }
//
//    static func search(for query: String, _ completion: @escaping (Response) -> Void) {
//        guard let url = build(searchTerm: query) else { return }
//        let session =  URLSession(configuration: .ephemeral)
//        let request = URLRequest(url: url)
//        session.load(request) { response in
//            completion(response)
//        }
//    }
//
//    static func search(forLookup: String?, completion: @escaping (Response) -> Void) {
//        guard let forLookup = forLookup else { return }
//        guard let url = URL(string: "https://itunes.apple.com/lookup?id=\(forLookup)&entity=podcast&limit=15") else { return }
//        let request = URLRequest(url: url)
//        let session = URLSession(configuration: .ephemeral)
//        session.load(request) { response in
//            completion(response)
//        }
//    }
//
//    static func build(searchTerm: String) -> URL? {
//        guard let encodedQuery = searchTerm.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return nil }
//        let urlString = URLRouter.base.url + URLRouter.path.url + encodedQuery
//        print(urlString)
//        return URL(string: urlString)
//    }
//}
//
//extension NetworkService {
//
//    internal func downloadTrackPreview(for download: Download?) {
//        if let download = download, let urlString = download.url, let url = URL(string: urlString) {
//            download.downloadTask = downloadsSession.downloadTask(with: url)
//            download.downloadTask?.resume()
//        }
//    }
//
//    func startDownload(_ download: Download?) {
//        if let newDownload = download, let urlString = newDownload.url {
//            activeDownloads[urlString] = newDownload
//            downloadTrackPreview(for: download)
//        }
//    }
//}
//
//extension NetworkService: URLSessionDelegate {
//
//    internal func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
//        if let appDelegate = UIApplication.shared.delegate as? AppDelegate,
//            let completionHandler = appDelegate.backgroundSessionCompletionHandler {
//            appDelegate.backgroundSessionCompletionHandler = nil
//            DispatchQueue.main.async {
//                completionHandler()
//            }
//        }
//    }
//
//    internal func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64,totalBytesExpectedToWrite: Int64) {
//        if let downloadUrl = downloadTask.originalRequest?.url?.absoluteString {
//            let progress =  Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
//            delegate?.download(progress: progress)
//            if progress == 1 {
//                activeDownloads[downloadUrl] = nil
//                // session.invalidateAndCancel()
//            }
//        }
//    }
//
//    internal func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
//        if let error = error {
//            print(error.localizedDescription)
//        } else {
//            print("The task finished transferring data successfully")
//            session.invalidateAndCancel()
//        }
//    }
//}
//
//extension NetworkService: URLSessionDownloadDelegate {
//
//    internal func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
//        guard let sourceURL = downloadTask.originalRequest?.url else { return }
//        activeDownloads[sourceURL.absoluteString] = nil
//        let destinationURL = LocalStorageManager.localFilePath(for: sourceURL)
//        let fileManager = FileManager.default
//        try? fileManager.removeItem(at: destinationURL)
//        do {
//            try fileManager.copyItem(at: location, to: destinationURL)
//            print(destinationURL.absoluteString)
//            delegate?.download(location: destinationURL.absoluteString)
//        } catch let error {
//            print("Could not copy file to disk: \(error.localizedDescription)")
//        }
//    }
//}
