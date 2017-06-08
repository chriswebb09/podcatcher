import UIKit

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
}

extension LoadingPopover {
    
    func setupPop(popView: LoadingView) {
        popView.configureView()
        popView.backgroundColor = .clear
    }
}
