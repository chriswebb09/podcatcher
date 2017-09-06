import UIKit

final class LoadingPopover: BasePopoverAlert {
    
    var animating: Bool {
        guard let ball = self.popView.ball else { return false }
        return ball.isAnimating
    }
    
    var popView: LoadingView = {
        let popView = LoadingView()
        popView.layer.cornerRadius = DetailPopoverConstants.cornerRadius
        popView.isUserInteractionEnabled = true
        return popView
    }()
    
    public override func showPopView(viewController: UIViewController) {
        super.showPopView(viewController: viewController)
        popView.frame = CGRect(x: UIScreen.main.bounds.midX,
                               y: UIScreen.main.bounds.midY,
                               width: UIScreen.main.bounds.width / 3,
                               height: UIScreen.main.bounds.height / 5.5)
        popView.center = CGPoint(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY)
        //popView.containerView.frame = viewController.view.frame
        popView.clipsToBounds = true
        viewController.view.addSubview(popView)
        viewController.view.bringSubview(toFront: popView)
        containerView.backgroundColor = .black
        containerView.alpha = 0.4
        containerView.frame = UIScreen.main.bounds
    }
    
    override func hidePopView(viewController: UIViewController) {
        super.hidePopView(viewController: viewController)
        viewController.view.sendSubview(toBack: popView)
        popView.stopAnimating()
        popView.removeFromSuperview()
    }
    
    func setupPop() {
        popView.configureView()
        popView.backgroundColor = .white
        popView.alpha = 0.8
    }
    
    func configureLoadingOpacity(alpha: CGFloat) {
        containerView.alpha = alpha
    }
    
    func show(controller: UIViewController) {
        setupPop()
        showPopView(viewController: controller)
        popView.isHidden = false
    }
    
    func hideLoadingView(controller: UIViewController) {
        popView.removeFromSuperview()
        removeFromSuperview()
        popView.ball?.removeFromSuperview()
        hidePopView(viewController: controller)
        controller.view.sendSubview(toBack: self)
    }
}
