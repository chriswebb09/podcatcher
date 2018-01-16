//
//  LoadingPresenting.swift
//  PodCatcher
//
//  Created by Christopher Webb-Orenstein on 1/12/18.
//  Copyright © 2018 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

protocol LoadingPresenting {
    func showLoadingView(loadingPop: LoadingPopover)
    func hideLoadingView(loadingPop: LoadingPopover)
}

extension LoadingPresenting where Self: UIViewController {
    
    func showLoadingView(loadingPop: LoadingPopover) {
        loadingPop.show(controller: self)
    }
    
    func hideLoadingView(loadingPop: LoadingPopover) {
        loadingPop.hidePopView(viewController: self)
    }
}
