import UIKit

struct LoadingViewConstants {
    static let frameOriginX: CGFloat = 0
    static let frameOriginY: CGFloat = 0
    static let frameWidth: CGFloat = 80
    static let frameHeight: CGFloat = 80
    static let cornerRadius: CGFloat = 10
    static let backgroundColor: UIColor = UIColor(red:0.27, green:0.27, blue:0.27, alpha:0.8)
    
    struct ActivityIndicator {
        static let originXY: CGFloat = 0
        static let width: CGFloat = 40
        static let height: CGFloat = 40
        static let containerCenterX: CGFloat = UIScreen.main.bounds.width / 2
        static let containerCenterY: CGFloat = UIScreen.main.bounds.height / 2.5
    }
}

class DownloaderIndicatorView: UIView {
    
    var percentageCompleteLabel: UILabel = {
        var label = UILabel()
        return label
    }()
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        return activityIndicator
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
                                   width: LoadingViewConstants.frameWidth,
                                   height: LoadingViewConstants.frameHeight)
        
        loadingView.center = CGPoint(x: UIScreen.main.bounds.midX,
                                     y: UIScreen.main.bounds.midY)
        loadingView.clipsToBounds = true
    }
    
    func addSubviews(viewController:UIViewController) {
        loadingView.addSubview(activityIndicator)
        containerView.addSubview(loadingView)
        viewController.view.addSubview(containerView)
    }
    
    func activityIndicatorSetup() {
        activityIndicator.frame = CGRect(x: LoadingViewConstants.ActivityIndicator.originXY, y: LoadingViewConstants.ActivityIndicator.originXY,
                                         width: LoadingViewConstants.ActivityIndicator.width, height: LoadingViewConstants.ActivityIndicator.height)
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.white
        activityIndicator.center = CGPoint(x: loadingView.frame.size.width / 2, y: loadingView.frame.size.height / 2)
        
    }
    
    func showActivityIndicator(viewController: UIViewController) {
        containerView.frame = UIScreen.main.bounds
        containerView.center = CGPoint(x: LoadingViewConstants.ActivityIndicator.containerCenterX,
                                       y: LoadingViewConstants.ActivityIndicator.containerCenterY)
        addLoadingView()
        activityIndicatorSetup()
        addSubviews(viewController: viewController)
        activityIndicator.startAnimating()
    }
    
    func hideActivityIndicator(viewController:UIViewController){
        viewController.view.sendSubview(toBack: containerView)
        activityIndicator.stopAnimating()
    }
}
