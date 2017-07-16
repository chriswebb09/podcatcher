import UIKit

final class Download {
    
    weak var delegate: DownloadDelegate?
    
    var url: String?
    var downloadTask: URLSessionDownloadTask?
    
    var locationString: String = "" {
        didSet {
            updateLocation(string: locationString)
        }
    }
    var progress: Float = 0.0 {
        didSet {
            updateProgress(with: progress)
        }
    }
    
    private func updateLocation(string: String) {
        delegate?.download(location: string)
    }
    
    // Gives float for download progress - for delegate
    
    private func updateProgress(with value: Float) {
        delegate?.download(progress: value)
       // delegate?.downloadProgressUpdated(for: progress)
    }
    
    init(url: String) {
        self.url = url
    }
    
    func getProgress(completion: @escaping (Float) -> Void) {
        if progress > 0 {
            completion(progress)
        }
    }
}

extension Download {
    
    func getDownloadURL() -> URL? {
        if let url = self.url {
            return URL(string: url)
        }
        return nil
    }
    
}
