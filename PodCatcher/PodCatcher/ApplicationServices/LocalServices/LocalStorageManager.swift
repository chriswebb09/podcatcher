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
    
    static func localFileExistsForFile(_ urlString: String) -> Bool {
        if let localUrl = LocalStorageManager.localFilePathForUrl(urlString) {
            var isDir : ObjCBool = false
            return FileManager.default.fileExists(atPath: localUrl.path , isDirectory: &isDir)
        }
        return false
    }
    
    
    static func getLocalFilePath(_ urlString: String) -> String {
        if let localUrl = LocalStorageManager.localFilePathForUrl(urlString) {
            var isDir : ObjCBool = false
           // return FileManager.default.fileExists(atPath: localUrl.path , isDirectory: &isDir)
            return localUrl.path
        }
        return ""
    }

}
