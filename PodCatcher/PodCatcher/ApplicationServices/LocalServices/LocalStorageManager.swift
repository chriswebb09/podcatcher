import Foundation

final class LocalStorageManager {
    
    static func localFilePathForUrl(_ previewUrl: String) -> URL? {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
        if let url = URL(string: previewUrl) {
            let fullPath = documentsPath.appendingPathComponent(url.lastPathComponent)
            return URL(fileURLWithPath: fullPath)
        }
        return nil
    }
}
