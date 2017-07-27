import UIKit

final class ConfirmationIndicatorView: UIView {
    
    var percentageCompleteLabel: UILabel = {
        var label = UILabel()
        label.text = "Subscribed"
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 18, weight: UIFontWeightRegular)
        label.sizeToFit()
        return label
    }()
    
    lazy var containerView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = .clear
        return containerView
    }()
    
    lazy var loadingView: UIView = {
        let loadingView = UIView()
        loadingView.layer.cornerRadius = LoadingViewConstants.cornerRadius
        loadingView.backgroundColor = LoadingViewConstants.backgroundColor
        return loadingView
    }()
    
    func addLoadingView() {
        loadingView.frame = CGRect(x: LoadingViewConstants.frameOriginX,
                                   y: LoadingViewConstants.frameOriginY,
                                   width: ConfirmLoadingViewConstants.frameWidth,
                                   height: ConfirmLoadingViewConstants.frameHeight)
        
        loadingView.center = CGPoint(x: UIScreen.main.bounds.midX,
                                     y: UIScreen.main.bounds.midY)
        loadingView.clipsToBounds = true
    }
    
    func addSubviews(viewController: UIViewController) {
        loadingView.addSubview(percentageCompleteLabel)
        containerView.addSubview(loadingView)
        viewController.view.addSubview(containerView)
    }
    
    func activityIndicatorSetup() {
        percentageCompleteLabel.frame = CGRect(x: LoadingViewConstants.ActivityIndicator.originXY,
                                               y: LoadingViewConstants.ActivityIndicator.originXY,
                                               width: ConfirmLoadingViewConstants.ActivityIndicator.width,
                                               height: ConfirmLoadingViewConstants.ActivityIndicator.height)
        percentageCompleteLabel.center = CGPoint(x: loadingView.frame.size.width / 2,
                                                 y: loadingView.frame.size.height / 2)
    }
    
    func showActivityIndicator(viewController: UIViewController) {
        containerView.frame = UIScreen.main.bounds
        containerView.center = CGPoint(x: LoadingViewConstants.ActivityIndicator.containerCenterX,
                                       y: LoadingViewConstants.ActivityIndicator.containerCenterY)
        addLoadingView()
        activityIndicatorSetup()
        addSubviews(viewController: viewController)
        viewController.view.bringSubview(toFront: loadingView)
    }
    
    func hideActivityIndicator(viewController: UIViewController) {
        viewController.view.sendSubview(toBack: containerView)
        containerView.removeFromSuperview()
    }
}
