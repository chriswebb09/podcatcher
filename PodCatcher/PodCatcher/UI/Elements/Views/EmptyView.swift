import UIKit

final class EmptyView: UIView {
    
    private var infoLabel: UILabel = {
        var label = UILabel.setupInfoLabel(infoText: "Subscribe To Your Favorite Podcasts!")
        label.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.medium)
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
    
    private var musicIcon: UIImageView = {
        var musicIcon = UIImageView()
        musicIcon.image = #imageLiteral(resourceName: "mic-icon").withRenderingMode(.alwaysTemplate)
        musicIcon.alpha = 1
        return musicIcon
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = UIColor(red:0.32, green:0.13, blue:0.70, alpha:1.0)
        setup(musicIcon: musicIcon)
        setup(infoLabel: infoLabel)
        addSubview(backgroundImageView)
    }
    
    func configure() {
        layoutSubviews()
    }
    
    private func setup(musicIcon: UIView) {
        addSubview(musicIcon)
        musicIcon.translatesAutoresizingMaskIntoConstraints = false
        musicIcon.heightAnchor.constraint(equalTo: heightAnchor, multiplier: EmptyViewConstants.iconHeightMultiplier).isActive = true
        musicIcon.widthAnchor.constraint(equalTo: widthAnchor, multiplier: EmptyViewConstants.iconWidthMutliplier).isActive = true
        musicIcon.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        musicIcon.centerYAnchor.constraint(equalTo: centerYAnchor, constant: UIScreen.main.bounds.height * -0.1).isActive = true
    }
    
    func setIcon(icon: UIImage) {
        musicIcon.image = icon
    }
    
    func setLabel(text: String) {
        infoLabel.text = text
    }
    
    private func setup(infoLabel: UILabel) {
        addSubview(infoLabel)
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        infoLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: EmptyViewConstants.iconWidthMutliplier).isActive = true
        infoLabel.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        infoLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        infoLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: UIScreen.main.bounds.height * 0.06).isActive = true
    }
}
