import Foundation

class TopPodcastLoadOperation: Operation {
    var topItem: CasterSearchResult?
    var loadingCompleteHandler: ((CasterSearchResult) -> ())?
    
    private let _topItem: CasterSearchResult
    
    init(_ topItem: CasterSearchResult) {
        _topItem = topItem
    }
    
    override func main() {
        if isCancelled { return }
        self.topItem = _topItem
        
        if let loadingCompleteHandler = loadingCompleteHandler {
            DispatchQueue.main.async {
                loadingCompleteHandler(self._topItem)
            }
        }
    }
}
