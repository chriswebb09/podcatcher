import UIKit

enum DownloadStatus {
    case pending, downloading, paused, failed, completed
}

final class Download {
    
    var url: String?
    var downloadTask: URLSessionDownloadTask?
    
    var locationString: String = ""
    
    // Gives float for download progress - for delegate
    
    init(url: String) {
        self.url = url
    }
    
    func getDownloadURL() -> URL? {
        if let url = self.url {
            return URL(string: url)
        }
        return nil
    }
}
