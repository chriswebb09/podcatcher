import UIKit

protocol LoadingViewProtocol {
    var loadingPop: LoadingPopover { get set }
}

extension LoadingViewProtocol {
    func showLoadingView(loadingPop: LoadingPopover, controller: UIViewController) {
        loadingPop.show(controller: controller)
    }
    
    func hideLoadingView(loadingPop: LoadingPopover, controller: UIViewController) {
        loadingPop.hidePopView(viewController: controller)
    }
}
