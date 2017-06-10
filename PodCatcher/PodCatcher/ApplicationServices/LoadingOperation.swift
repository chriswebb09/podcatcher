//
//  LoadingOperation.swift
//  PodCatcher
//
//  Created by Christopher Webb-Orenstein on 6/8/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

class DataLoadOperation: Operation {
    var test: String?
    //var loadingCompleteHandler: ((EmojiRating) -> ())?
    
    var loadingCompletion: ((String) -> Void)?
    private let _test:  String
    
    init(_ test: String) {
        _test = test
    }
    
    override func main() {
        if isCancelled { return }
        
        let randomDelayTime = arc4random_uniform(2000) + 500
        usleep(randomDelayTime * 1000)
        
        if isCancelled { return }
        self.test = _test
        
        if let loadingCompletion = loadingCompletion {
            DispatchQueue.main.async {
                loadingCompletion(self._test)
            }
        }
    }
    
}
