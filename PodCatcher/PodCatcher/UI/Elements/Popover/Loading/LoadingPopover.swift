import UIKit

class LoadingHUD {
    
    var loadingView: LoadingView = {
        let loadingView = LoadingView()
        loadingView.isUserInteractionEnabled = true
        return loadingView
    }()
    
    func setIndicator(_ size: CGSize) {
        loadingView.frame.size = size
    }
    
    func setIndicator(_ origin: CGPoint) {
        loadingView.frame.origin = origin
    }
    
    func showOn(_ view: UIView) {
        view.addSubview(loadingView)
        loadingView.configureView()
        view.bringSubview(toFront: loadingView)
        let ball = BallIndicatorView(frame: view.frame)
        loadingView.stopAnimating(ball: ball)
        
    }
    
    func hideFrom(_ view: UIView) {
        view.sendSubview(toBack: loadingView)
        loadingView.ball?.removeFromSuperview()
        loadingView.removeFromSuperview()
        guard let ball = loadingView.ball else { return }
        loadingView.stopAnimating(ball: ball)
    }
}

final class LoadingPopover: BasePopoverAlert {
    
    var popView: LoadingView = {
        let popView = LoadingView()
        popView.layer.cornerRadius = DetailPopoverConstants.cornerRadius
        popView.backgroundColor = .clear
        popView.isUserInteractionEnabled = true
        return popView
    }()
    
    public override func showPopView(viewController: UIViewController) {
        super.showPopView(viewController: viewController)
        popView.frame = CGRect(x: UIScreen.main.bounds.midX,
                               y: UIScreen.main.bounds.midY,
                               width: UIScreen.main.bounds.width / 2,
                               height: UIScreen.main.bounds.height / 2)
        popView.center = CGPoint(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY)
        popView.clipsToBounds = true
        viewController.view.addSubview(popView)
        viewController.view.bringSubview(toFront: popView)
    }
    
    override func hidePopView(viewController: UIViewController) {
        super.hidePopView(viewController: viewController)
        guard let ball = popView.ball else { return }
        popView.stopAnimating(ball: ball)
    }
    
    
    func setupPop(popView: LoadingView) {
        popView.configureView()
        popView.backgroundColor = .clear
    }
    
    func configureLoadingOpacity() {
        containerView.backgroundColor = .clear
    }
    
    func show(controller: UIViewController) {
        setupPop(popView: popView)
        showPopView(viewController: controller)
        popView.isHidden = false
    }
    
    func hideLoadingView(controller: UIViewController) {
        popView.removeFromSuperview()
        removeFromSuperview()
        hidePopView(viewController: controller)
        controller.view.sendSubview(toBack: self)
    }
}

