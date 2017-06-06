import UIKit

typealias completion = () -> Void

final class SplashView: UIView {
    
    weak var delegate: SplashViewDelegate?
    
    var animationDuration: Double = 0.5
    
    var speakerZero: UIImageView = {
        let image = #imageLiteral(resourceName: "speakerblue-0")
        let imageView = UIImageView(image: image)
        return imageView
    }()
    
    
    // MARK: - Configure
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addSubview(speakerZero)
        frame = UIScreen.main.bounds
        setupConstraints(logoImageView:speakerZero)
        backgroundColor = .white
    }
    
    func setupImageView(logoImageView: UIImageView) {
        addSubview(logoImageView)
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: LogoConstants.logoImageWidth).isActive = true
        logoImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: LogoConstants.logoImageHeight).isActive = true
        logoImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        logoImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    private func setupConstraints(logoImageView: UIImageView) {
        addSubview(logoImageView)
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: LogoConstants.logoImageWidth).isActive = true
        logoImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: LogoConstants.logoImageHeight).isActive = true
        logoImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        logoImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        setupImageView(logoImageView: speakerZero)
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
