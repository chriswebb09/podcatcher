import UIKit

typealias completion = () -> Void

final class SplashView: UIView {
    
    weak var delegate: SplashViewDelegate?
    
    var animationDuration: Double = 0.5
    
    // MARK: - UI Properties
    
    var speakerZero: UIImageView = {
        let image = #imageLiteral(resourceName: "speakerblue-0")
        let imageView = UIImageView(image: image)
        return imageView
    }()
    
    // MARK: - Configuration methods
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addSubview(speakerZero)
        frame = UIScreen.main.bounds
        setup(logoImageView: speakerZero)
        backgroundColor = .white
    }
    
    func setup(logoImageView: UIImageView) {
        addSubview(logoImageView)
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: LogoConstants.logoImageWidth).isActive = true
        logoImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: LogoConstants.logoImageHeight).isActive = true
        logoImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        logoImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    // MARK: - Animation
    
    func zoomAnimation(_ handler: completion? = nil) {
        let duration: TimeInterval = animationDuration
        speakerZero.isHidden = false
        alpha = LogoConstants.startAlpha
        UIView.animate(withDuration: duration, animations: { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.speakerZero.transform = LogoConstants.zoomOutTranform
            strongSelf.alpha = 0
            }, completion: { finished in
                DispatchQueue.main.async {
                    self.delegate?.animationIsComplete()
                }
                handler?()
        })
    }
}
