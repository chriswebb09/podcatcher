//
//  PodcastSearchResultLoadOp.swift
//  PodCatcher
//
//  Created by Christopher Webb-Orenstein on 8/7/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import Foundation
import UIKit

final class PodcastSearchResultLoadOperation: Operation {
    
    var topItem: Podcast?
    
    var loadingCompleteHandler: ((Podcast) -> ())?
    
    private let _topItem: Podcast
    
    private var _executing = false {
        willSet {
            willChangeValue(forKey: "isExecuting")
        }
        didSet {
            didChangeValue(forKey: "isExecuting")
        }
    }
    
    override var isExecuting: Bool {
        return _executing
    }
    
    private var _finished = false {
        willSet {
            willChangeValue(forKey: "isFinished")
        }
        
        didSet {
            didChangeValue(forKey: "isFinished")
        }
    }
    
    override var isFinished: Bool {
        return _finished
    }
    
    func executing(_ executing: Bool) {
        _executing = executing
    }
    
    func finish(_ finished: Bool) {
        _finished = finished
    }
    
    init(_ topItem: Podcast) {
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
