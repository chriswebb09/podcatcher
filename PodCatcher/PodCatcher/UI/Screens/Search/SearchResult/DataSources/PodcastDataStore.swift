import UIKit

class PodcastDataStore {
    
    let client = iTunesAPIClient()
    
    func getFile(_ download: Download) {
        client.startDownload(download)
    }
    
    func downloadTrack(for url: URL) {
        let download = Download(url: url.absoluteString)
        client.startDownload(download)
    }
}
