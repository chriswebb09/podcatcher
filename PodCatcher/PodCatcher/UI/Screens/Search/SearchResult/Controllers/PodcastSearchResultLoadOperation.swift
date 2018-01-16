//
//  PodcastSearchResultLoadOperation.swift
//  PodCatcher
//
//  Created by Christopher Webb-Orenstein on 1/12/18.
//  Copyright © 2018 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

final class PodcastSearchResultLoadOperation: Operation {
    
    var topItem: PodcastSearchResult?
    
    var loadingCompleteHandler: ((PodcastSearchResult) -> ())?
    
    private let _topItem: PodcastSearchResult
    
    init(_ topItem: PodcastSearchResult) {
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
