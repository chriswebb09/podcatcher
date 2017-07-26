import UIKit

final class LoadingView: UIView {
    
    var ball: BallIndicatorView?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.masksToBounds = true
    }
    
    func configureView() {
        layoutSubviews()
        setupConstraints()
    }
    
    func startAnimating(ball: BallIndicatorView) {
        ball.startAnimating()
    }
    
    func stopAnimating(ball: BallIndicatorView) {
        ball.stopAnimating()
    }
    
    private func setupConstraints() {
        let newFrame = CGRect(x: 0, y: -10, width: UIScreen.main.bounds.width / 2, height: UIScreen.main.bounds.width / 2.1)
        let size = CGSize(width: 50, height: 20)
        ball = BallIndicatorView(frame: newFrame, color: UIColor(red:0.94, green:0.31, blue:0.81, alpha:1.0), padding: 80, animationType: BallAnimation(size: size))
        guard let ball = ball else { return }
        addSubview(ball)
        bringSubview(toFront: ball)
        ball.startAnimating()
    }
}

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
                               width: UIScreen.main.bounds.width / 2,
                               height: UIScreen.main.bounds.height / 4)
        popView.center = CGPoint(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY)
        popView.clipsToBounds = true
        viewController.view.addSubview(popView)
        viewController.view.bringSubview(toFront: popView)
    }
    
    override func hidePopView(viewController: UIViewController) {
        super.hidePopView(viewController: viewController)
        guard let ball = popView.ball else { return }
        viewController.view.sendSubview(toBack: popView)
        popView.stopAnimating(ball: ball)
        popView.removeFromSuperview()
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
