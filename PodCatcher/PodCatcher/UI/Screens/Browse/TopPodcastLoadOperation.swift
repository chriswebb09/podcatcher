import Foundation

final class TopPodcastLoadOperation: Operation {
    var topItem: PodcastItem?
    var loadingCompleteHandler: ((PodcastItem) -> ())?
    
    private let _topItem: PodcastItem
    
    init(_ topItem: PodcastItem) {
        _topItem = topItem
    }
    
    override func main() {
        if isCancelled { return }
        self.topItem = _topItem
        
        if let loadingCompleteHandler = loadingCompleteHandler {
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else { return }
                loadingCompleteHandler(strongSelf._topItem)
            }
        }
    }
}
