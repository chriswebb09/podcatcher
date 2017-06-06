import UIKit

struct DetailPopoverConstants {
    static let cornerRadius: CGFloat = 10
    static let borderWidth: CGFloat = 10
    static let popViewFrameX: CGFloat = UIScreen.main.bounds.width * 0.5
    static let popViewFrameY: CGFloat = UIScreen.main.bounds.height * -0.5
    static let popViewFrameWidth: CGFloat = UIScreen.main.bounds.width * 0.9
    static let popViewFrameHeight: CGFloat = UIScreen.main.bounds.height * 0.55
    static let popViewFrameCenterY: CGFloat = UIScreen.main.bounds.height / 2.5
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
}

extension LoadingPopover {
    
    func setupPop(popView: LoadingView) {
        popView.configureView()
        popView.backgroundColor = .clear
    }
}
