import Foundation

import UIKit
//
//final class TopPodcastLoadOperation: Operation {
//    
//    var topItem: Podcast?
//    
//    var loadingCompleteHandler: ((Podcast) -> ())?
//    
//    private let _topItem: Podcast
//    
//    override var isAsynchronous: Bool {
//        return true
//    }
//    
//    var _isFinished: Bool = false
//    
//    override var isFinished: Bool {
//        set {
//            willChangeValue(forKey: "isFinished")
//            _isFinished = newValue
//            didChangeValue(forKey: "isFinished")
//        }
//        
//        get {
//            return _isFinished
//        }
//    }
//    
//    var _isExecuting: Bool = false
//    
//    override var isExecuting: Bool {
//        set {
//            willChangeValue(forKey: "isExecuting")
//            _isExecuting = newValue
//            didChangeValue(forKey: "isExecuting")
//        }
//        
//        get {
//            return _isExecuting
//        }
//    }
//    
//    private var _executing = false {
//        willSet {
//            willChangeValue(forKey: "isExecuting")
//        }
//        didSet {
//            didChangeValue(forKey: "isExecuting")
//        }
//    }
//    
//    private var _finished = false {
//        willSet {
//            willChangeValue(forKey: "isFinished")
//        }
//        
//        didSet {
//            didChangeValue(forKey: "isFinished")
//        }
//    }
//    
//    func executing(_ executing: Bool) {
//        _executing = executing
//    }
//    
//    func finish(_ finished: Bool) {
//        _finished = finished
//    }
//    
//    init(_ topItem: Podcast) {
//        _topItem = topItem
//    }
//    
//    override func main() {
//        if isCancelled { return }
//        self.topItem = _topItem
//        
//        if let loadingCompleteHandler = loadingCompleteHandler {
//            DispatchQueue.main.async { [weak self] in
//                guard let strongSelf = self else { return }
//                loadingCompleteHandler(strongSelf._topItem)
//            }
//        }
//    }
//}

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
//
