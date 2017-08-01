import UIKit

final class NoSearchResultsView: UIView {
    
    private var infoLabel: UILabel = {
        var label = UILabel.setupInfoLabel(infoText: "Could not locate any podcasts with that name.")
        label.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.medium)
        label.textColor = Colors.brightHighlight
        label.alpha = 1
        return label
    }()
    
    private var backgroundImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "whitebackground")
        imageView.alpha = 0.8
        return imageView
    }()
    
    private var podcastIcon: UIImageView = {
        var network = UIImageView()
        network.image = #imageLiteral(resourceName: "GrayPodcasts-icon copy").withRenderingMode(.alwaysTemplate)
        return network
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = UIColor(red:0.32, green:0.13, blue:0.70, alpha:1.0)
        setup(icon: podcastIcon)
        setup(infoLabel: infoLabel)
        addSubview(backgroundImageView)
        addBlurEffect()
    }
    
    func configure() {
        layoutSubviews()
    }
    
    func addBlurEffect() {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        backgroundImageView.addSubview(blurEffectView)
    }
    
    private func setup(icon: UIView) {
        addSubview(icon)
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.heightAnchor.constraint(equalTo: heightAnchor, multiplier: EmptyViewConstants.iconHeightMultiplier).isActive = true
        icon.widthAnchor.constraint(equalTo: widthAnchor, multiplier: EmptyViewConstants.iconWidthMutliplier).isActive = true
        icon.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        icon.centerYAnchor.constraint(equalTo: centerYAnchor, constant: EmptyViewConstants.iconCenterYOffset).isActive = true
    }
    
    private func setup(infoLabel: UILabel) {
        addSubview(infoLabel)
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        infoLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: EmptyViewConstants.iconWidthMutliplier).isActive = true
        infoLabel.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        infoLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        infoLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
}
