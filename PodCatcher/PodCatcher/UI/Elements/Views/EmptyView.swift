import UIKit

final class EmptyView: UIView {
    
    private var infoLabel: UILabel = UILabel.setupInfoLabel()
    
    private var musicIcon: UIImageView = {
        var musicIcon = UIImageView()
        musicIcon.image = #imageLiteral(resourceName: "headphones-blue")
        return musicIcon
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setup(musicIcon: musicIcon)
        setup(infoLabel: infoLabel)
        backgroundColor = CollectionViewAttributes.backgroundColor
    }
    
    func configure() {
        layoutSubviews()
    }
    
    private func setup(musicIcon: UIView) {
        addSubview(musicIcon)
        musicIcon.translatesAutoresizingMaskIntoConstraints = false
        musicIcon.heightAnchor.constraint(equalTo: heightAnchor, multiplier: EmptyViewConstants.musicIconHeightMultiplier).isActive = true
        musicIcon.widthAnchor.constraint(equalTo: widthAnchor, multiplier: EmptyViewConstants.musicIconWidthMutliplier).isActive = true
        musicIcon.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        musicIcon.centerYAnchor.constraint(equalTo: centerYAnchor, constant: EmptyViewConstants.musicIconCenterYOffset).isActive = true
    }
    
    private func setup(infoLabel: UILabel) {
        addSubview(infoLabel)
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        infoLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: EmptyViewConstants.musicIconWidthMutliplier).isActive = true
        infoLabel.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        infoLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        infoLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
}
