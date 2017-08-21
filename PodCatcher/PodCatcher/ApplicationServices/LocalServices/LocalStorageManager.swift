import Foundation

final class LocalStorageManager {
    
    static func localFilePathForUrl(_ previewUrl: String) -> URL? {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
        if let url = URL(string: previewUrl) {
            let podcastDir = documentsPath.appendingPathComponent("podcasts/\(url.lastPathComponent)")
            let fullPath = documentsPath.appendingPathComponent(url.lastPathComponent)
            return URL(fileURLWithPath: podcastDir)
        }
        return nil
    }
    
    static func localFileExists(for urlString: String) -> Bool {
        if let localUrl = LocalStorageManager.localFilePathForUrl(urlString) {
            var isDir : ObjCBool = false
            return FileManager.default.fileExists(atPath: localUrl.path , isDirectory: &isDir)
        }
        return false
    }
    
    static func getLocalFilePath(_ urlString: String) -> String {
        if let localUrl = LocalStorageManager.localFilePathForUrl(urlString) {
            return localUrl.path
        }
        return ""
    }
    
    static func localFilePath(for url: URL) -> URL {
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let podcastDir = documentsPath.appendingPathComponent("podcasts/\(url.lastPathComponent)")
        return podcastDir
    }
    
    static func makePodcastsDirectory() -> Bool {
        guard let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return false }
        do {
            try FileManager.default.createDirectory(at: url.appendingPathComponent("podcasts"), withIntermediateDirectories: false, attributes: nil)
            return true
        } catch let error as NSError {
            print(error.description)
            if error.code == 17 {
                return true
            } else {
                return false
            }
        }
    }
    
    fileprivate static func createDir(dirName: String) {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let dataPath = documentsDirectory.appendingPathComponent(dirName)
        
        do {
            try FileManager.default.createDirectory(atPath: dataPath.absoluteString, withIntermediateDirectories: false, attributes: nil)
        } catch let error as NSError {
            print("Error creating directory: \(error.localizedDescription)")
        }
    }
    
    static func deleteSavedItem(itemUrlString: String) {
        let fileManager = FileManager.default
        if let localUrl = LocalStorageManager.localFilePathForUrl(itemUrlString) {
            do {
                try fileManager.removeItem(at: localUrl)
            } catch let error {
                print(error.localizedDescription)
            }
            
        }
    }
}


extension FileManager.SearchPathDirectory {
    func createSubFolder(named: String, withIntermediateDirectories: Bool = false) -> Bool {
        guard let url = FileManager.default.urls(for: self, in: .userDomainMask).first else { return false }
        do {
            try FileManager.default.createDirectory(at: url.appendingPathComponent(named), withIntermediateDirectories: false, attributes: nil)
            return true
        } catch let error as NSError {
            print(error.description)
            return false
        }
    }
}

