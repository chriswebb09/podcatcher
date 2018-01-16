import UIKit

enum DownloadStatus {
    case pending, downloading, paused, failed, completed
}

final class Download: DataItem {
    
    var url: String?
    var downloadTask: URLSessionDownloadTask?
    
    var locationString: String = ""
    
    // Gives float for download progress - for delegate
    
    init(url: String) {
        self.url = url
    }
    
    init(from decoder: Decoder) throws {
        
    }
    
    func encode(to encoder: Encoder) throws {
        
    }
    
    func getDownloadURL() -> URL? {
        if let url = self.url {
            return URL(string: url)
        }
        return nil
    }
}
