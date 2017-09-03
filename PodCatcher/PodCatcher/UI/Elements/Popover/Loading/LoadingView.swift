import UIKit

final class LoadingView: UIView {
    
    var ball: BallIndicatorView?
    
    var containerView: UIView = UIView()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.masksToBounds = true
    }
    
    func configureView() {
        layoutSubviews()
        addSubview(containerView)
        containerView.frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.width / 3, height: frame.height / 3)
        setupConstraints()
        containerView.backgroundColor = .white
        containerView.alpha = 0.8
    }
    
    func setContainerViewAlpha(alpha: CGFloat) {
        containerView.alpha = alpha
    }
    
    func startAnimating() {
        ball?.startAnimating()
    }
    
    func stopAnimating() {
        ball?.stopAnimating()
    }
    
    private func setupConstraints() {
        let newFrame = CGRect(x: -35, y: -35, width: UIScreen.main.bounds.width / 2, height: UIScreen.main.bounds.width / 2.1)
        let size = CGSize(width: 70, height: 20)
        ball = BallIndicatorView(frame: newFrame, color: UIColor(red:0.00, green:0.70, blue:1.00, alpha:1.0), padding: 80, animationType: BallAnimation(size: size))
        guard let ball = ball else { return }
        addSubview(ball)
        bringSubview(toFront: ball)
        ball.startAnimating()
    }
}
