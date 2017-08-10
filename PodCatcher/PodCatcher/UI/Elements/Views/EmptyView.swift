import UIKit

protocol StateView {
    var stateData: String { get set }
    var stateImage: UIImage { get set }
    var informationLabel: UILabel { get }
    var iconView: UIImageView { get }
}

class InformationView: UIView, StateView {
    var stateData: String {
        didSet {
            informationLabel.text = stateData
        }
    }
    
    var stateImage: UIImage {
        didSet {
            iconView.image = stateImage
        }
    }
    
    var informationLabel: UILabel = {
        var label = UILabel.setupInfoLabel(infoText: "Subscribe To Your Favorite Podcasts!")
        label.font = UIFont.systemFont(ofSize: 16, weight: UIFontWeightMedium)
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
    
    var iconView: UIImageView = {
        var icon = UIImageView()
        return icon
    }()
    
    init(data: String, icon: UIImage) {
        self.stateData = data
        self.stateImage = icon
        super.init(frame: CGRect.zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = UIColor(red:0.32, green:0.13, blue:0.70, alpha:1.0)
        setup(musicIcon: iconView)
        setup(infoLabel: informationLabel)
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
        iconView.image = icon
        iconView.image  = icon.withRenderingMode(.alwaysTemplate)
        iconView.alpha = 1
    }
    
    func setLabel(text: String) {
        informationLabel.text = text
        informationLabel.font = UIFont.systemFont(ofSize: 16, weight: UIFontWeightMedium)
        informationLabel.textColor = Colors.brightHighlight
        informationLabel.alpha = 1
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
//
//class EmptyView: UIView {
//    
//    private var infoLabel: UILabel = {
//        var label = UILabel.setupInfoLabel(infoText: "Subscribe To Your Favorite Podcasts!")
//        label.font = UIFont.systemFont(ofSize: 16, weight: UIFontWeightMedium)
//        label.textColor = Colors.brightHighlight
//        label.alpha = 1
//        return label
//    }()
//    
//    private var backgroundImageView: UIImageView = {
//        var imageView = UIImageView()
//        imageView.image = #imageLiteral(resourceName: "whitebackground")
//        imageView.alpha = 0.8
//        return imageView
//    }()
//    
//    private var musicIcon: UIImageView = {
//        var musicIcon = UIImageView()
//        musicIcon.image = #imageLiteral(resourceName: "mic-icon").withRenderingMode(.alwaysTemplate)
//        musicIcon.alpha = 1
//        return musicIcon
//    }()
//    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        backgroundColor = UIColor(red:0.32, green:0.13, blue:0.70, alpha:1.0)
//        setup(musicIcon: musicIcon)
//        setup(infoLabel: infoLabel)
//        addSubview(backgroundImageView)
//    }
//    
//    func configure() {
//        layoutSubviews()
//    }
//    
//    private func setup(musicIcon: UIView) {
//        addSubview(musicIcon)
//        musicIcon.translatesAutoresizingMaskIntoConstraints = false
//        musicIcon.heightAnchor.constraint(equalTo: heightAnchor, multiplier: EmptyViewConstants.iconHeightMultiplier).isActive = true
//        musicIcon.widthAnchor.constraint(equalTo: widthAnchor, multiplier: EmptyViewConstants.iconWidthMutliplier).isActive = true
//        musicIcon.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
//        musicIcon.centerYAnchor.constraint(equalTo: centerYAnchor, constant: UIScreen.main.bounds.height * -0.1).isActive = true
//    }
//    
//    func setIcon(icon: UIImage) {
//        musicIcon.image = icon
//    }
//    
//    func setLabel(text: String) {
//        infoLabel.text = text
//    }
//    
//    private func setup(infoLabel: UILabel) {
//        addSubview(infoLabel)
//        infoLabel.translatesAutoresizingMaskIntoConstraints = false
//        infoLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: EmptyViewConstants.iconWidthMutliplier).isActive = true
//        infoLabel.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
//        infoLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
//        infoLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: UIScreen.main.bounds.height * 0.06).isActive = true
//    }
//}


final class PlaylistEmptyView: UIView {
    
    private var infoLabel: UILabel = {
        var label = UILabel.setupInfoLabel(infoText: "")
        label.font = UIFont.systemFont(ofSize: 15, weight: UIFontWeightMedium)
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
        musicIcon.image = nil
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
        musicIcon.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.36).isActive = true
        musicIcon.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.28).isActive = true
        musicIcon.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        musicIcon.centerYAnchor.constraint(equalTo: centerYAnchor, constant: UIScreen.main.bounds.height * -0.06).isActive = true
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
        infoLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.3).isActive = true
        infoLabel.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        infoLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        infoLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: UIScreen.main.bounds.height * 0.06).isActive = true
    }
}
