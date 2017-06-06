import UIKit

final class LoadingView: UIView {
    
    var ball: BallIndicatorView?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        isUserInteractionEnabled = true
        layer.borderColor = UIColor.clear.cgColor
        layer.masksToBounds = true
    }
    
    func configureView() {
        layoutSubviews()
        setupConstraints()
        layer.borderWidth = 2
    }
    
    func startAnimating(ball: BallIndicatorView) {
        ball.startAnimating()
    }
    
    func stopAnimating(ball: BallIndicatorView) {
        ball.stopAnimating()
    }
    
    private func setupConstraints() {
        let newFrame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width / 2, height: UIScreen.main.bounds.width / 2)
        ball = BallIndicatorView(frame: newFrame, color: .white, padding: 80)
        guard let ball = ball else { return }
        addSubview(ball)
        bringSubview(toFront: ball)
        ball.startAnimating()
    }
}
