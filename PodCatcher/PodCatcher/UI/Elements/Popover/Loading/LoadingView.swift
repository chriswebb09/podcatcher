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
