import UIKit

final class BrowseSection: UIView {
    
    var titleLabel: UILabel = {
        let title = UILabel()
        title.textColor = UIColor(red:0.24, green:0.24, blue:0.24, alpha:1.0)
        title.font = Style.Font.PlaylistCell.title
        title.text = "Podcasts"
        
        //UIFont(name: "AvenirNext-Regular", size: 17)
        title.textAlignment = .left
        // title.numberOfLines = 0
        return title
    }()
    
    var goToLabel: UILabel = {
        let title = UILabel()
        title.textColor = UIColor(red:0.62, green:0.62, blue:0.62, alpha:1.0)
        title.font = Style.Font.PlaylistCell.title
        title.text = "Podcasts"
        title.textAlignment = .left
        title.numberOfLines = 0
        return title
        
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = UIColor(red:0.96, green:0.96, blue:0.96, alpha:1.0)
            //UIColor(red:0.91, green:0.91, blue:0.91, alpha:1.0)
            //UIColor(red:0.97, green:0.97, blue:0.97, alpha:1.0)
        setup(titleLabel: titleLabel)
        layer.borderWidth = 1
        layer.borderColor = UIColor.lightGray.cgColor
    }
    
    func setup(titleLabel: UILabel) {
        self.addSubview(titleLabel)
        print("here")
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 480:
                if #available(iOS 11, *) {
                    titleLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
                    // titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 10).isActive = true
                } else {
                    titleLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
                    // titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: bounds.width * 0.13).isActive = true
                }
                titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
                titleLabel.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.29).isActive = true
                titleLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.3).isActive = true
                titleLabel.layoutIfNeeded()
            case 960:
                if #available(iOS 11, *) {
                    titleLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
                   // titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 10).isActive = true
                } else {
                    titleLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
                   // titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: bounds.width * 0.13).isActive = true
                }
                
                titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
                titleLabel.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.29).isActive = true
                titleLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.3).isActive = true
                titleLabel.layoutIfNeeded()
            case 1136:
                if #available(iOS 11, *) {
                    titleLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
                    // titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 10).isActive = true
                } else {
                    titleLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
                    // titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: bounds.width * 0.13).isActive = true
                }
                
                titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
                titleLabel.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.29).isActive = true
                titleLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.3).isActive = true
                titleLabel.layoutIfNeeded()
                
            case 1334:
                if #available(iOS 11, *) {
                    titleLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
                    // titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 10).isActive = true
                } else {
                    titleLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
                    // titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: bounds.width * 0.13).isActive = true
                }
                titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
                titleLabel.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.34).isActive = true
                titleLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.3).isActive = true
                titleLabel.layoutIfNeeded()
                
                
            case 2208:
                if #available(iOS 11, *) {
                    titleLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
                    // titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 10).isActive = true
                } else {
                    titleLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
                    // titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: bounds.width * 0.13).isActive = true
                }
                
                titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
                titleLabel.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.29).isActive = true
                titleLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.3).isActive = true
                titleLabel.layoutIfNeeded()
                
            default:
                if #available(iOS 11, *) {
                    titleLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
                    // titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 10).isActive = true
                } else {
                    titleLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
                    // titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: bounds.width * 0.13).isActive = true
                }
                titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
                titleLabel.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.29).isActive = true
                titleLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.3).isActive = true
                titleLabel.layoutIfNeeded()
            }
        }
      
    }
}

final class BrowseTopView: UIView {
    
    var index: Int = 0 
    
    weak var delegate: TopViewDelegate?
    
    // MARK: - UI Properties
    let sliderBarView = UIView()
    var sliderControl = SliderControl()
    
    
    var titleLabel: UILabel = {
        let title = UILabel()
        title.textColor = .white
        //UIColor(red:0.24, green:0.24, blue:0.24, alpha:1.0)
        title.font = UIFont(name: "AvenirNext-DemiBold", size: 24)
        //Style.Font.PlaylistCell.title
        //   title.text = "Podcasts"
        //UIFont(name: "AvenirNext-Regular", size: 17)
        title.textAlignment = .center
        title.numberOfLines = 0
        return title
    }()
    
    var podcastImageView: UIImageView! = {
        var podcastImageView = UIImageView()
        podcastImageView.layer.setCellShadow(contentView: podcastImageView)
        podcastImageView.layer.cornerRadius = 2
        return podcastImageView
    }()
    
    var background = UIView()
    
    var podcastTitleLabel: UILabel! = {
        var podcastTitle = UILabel()
        podcastTitle.textAlignment = .center
        return podcastTitle
    }()
    
    var overlayView: UIView = {
        let overlay = UIView()
        overlay.backgroundColor = .black
        overlay.alpha = 0.3
        return overlay
    }()
    
    var dataView: UIView = {
        var dataView = UIView()
        dataView.backgroundColor = .clear
        return dataView
    }()
    
    var preferencesView: PreferencesView = {
        var preferencesView = PreferencesView()
        preferencesView.layoutSubviews()
        return preferencesView
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        add(dataView)
        addSubview(background)
        background.frame = frame
        sendSubview(toBack: background)
        setupConstraints()
        bringSubview(toFront: overlayView)
        layer.setCellShadow(contentView: self)
        layoutIfNeeded()
        
        background.backgroundColor = UIColor(red:0.19, green:0.23, blue:0.26, alpha:1.0)
    }
    
    func setupConstraints() {
        setup(podcastImageView: podcastImageView)
        
        setup(dataView: dataView)
        setup(overlayView: overlayView)
        setup(titleLabel: titleLabel)
        //setup(titleLabel: podcastTitleLabel)
        preferencesView.layoutSubviews()
    }
    
    func setup(podcastImageView: UIImageView) {
        addSubview(podcastImageView)
        podcastImageView.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 11, *) {
            NSLayoutConstraint.activate([
                podcastImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
                podcastImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
                podcastImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.9),
                podcastImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.6)
                ])
        } else {
            NSLayoutConstraint.activate([
                podcastImageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: BrowseListTopViewConstants.podcastImageViewCenterYOffset),
                podcastImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
                podcastImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: BrowseListTopViewConstants.podcastImageViewHeightMultiplier),
                podcastImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: BrowseListTopViewConstants.podcastImageViewWidthMultiplier)
                ])
            podcastImageView.layoutIfNeeded()
            layoutIfNeeded()
        }
    }
    
    func setup(dataView: UIView) {
        add(dataView)
        dataView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dataView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            dataView.widthAnchor.constraint(equalTo: widthAnchor),
            dataView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 1)
            ])
    }
    
    func setup(overlayView: UIView) {
        dataView.add(overlayView)
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            overlayView.topAnchor.constraint(equalTo: dataView.topAnchor, constant: 0),
            overlayView.widthAnchor.constraint(equalTo: dataView.widthAnchor),
            overlayView.heightAnchor.constraint(equalTo: dataView.heightAnchor, multiplier: 1)
            ])
    }
    
    func setup(titleLabel: UILabel) {
        dataView.add(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            titleLabel.centerXAnchor.constraint(equalTo: dataView.centerXAnchor, constant: 0),
//            titleLabel.widthAnchor.constraint(equalTo: dataView.widthAnchor),
//            titleLabel.centerYAnchor.constraint(equalTo: dataView.centerYAnchor),
//            titleLabel.heightAnchor.constraint(equalTo: dataView.heightAnchor, multiplier: 0.3)
//            ])
        
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 480:
                NSLayoutConstraint.activate([
                    titleLabel.centerXAnchor.constraint(equalTo: dataView.centerXAnchor, constant: 0),
                    titleLabel.widthAnchor.constraint(equalTo: dataView.widthAnchor),
                    titleLabel.centerYAnchor.constraint(equalTo: dataView.centerYAnchor),
                    titleLabel.heightAnchor.constraint(equalTo: dataView.heightAnchor, multiplier: 0.3)
                    ])
            case 960:
                NSLayoutConstraint.activate([
                    titleLabel.centerXAnchor.constraint(equalTo: dataView.centerXAnchor, constant: 0),
                    titleLabel.widthAnchor.constraint(equalTo: dataView.widthAnchor),
                    titleLabel.centerYAnchor.constraint(equalTo: dataView.centerYAnchor),
                    titleLabel.heightAnchor.constraint(equalTo: dataView.heightAnchor, multiplier: 0.3)
                    ])
            case 1136:
                NSLayoutConstraint.activate([
                    titleLabel.centerXAnchor.constraint(equalTo: dataView.centerXAnchor, constant: 0),
                    titleLabel.widthAnchor.constraint(equalTo: dataView.widthAnchor),
                    titleLabel.centerYAnchor.constraint(equalTo: dataView.centerYAnchor),
                    titleLabel.heightAnchor.constraint(equalTo: dataView.heightAnchor, multiplier: 0.4)
                    ])

            case 1334:
                NSLayoutConstraint.activate([
                    titleLabel.centerXAnchor.constraint(equalTo: dataView.centerXAnchor, constant: 0),
                    titleLabel.widthAnchor.constraint(equalTo: dataView.widthAnchor),
                    titleLabel.centerYAnchor.constraint(equalTo: dataView.centerYAnchor),
                    titleLabel.heightAnchor.constraint(equalTo: dataView.heightAnchor, multiplier: 0.4)
                    ])

                
            case 2208:
                NSLayoutConstraint.activate([
                    titleLabel.centerXAnchor.constraint(equalTo: dataView.centerXAnchor, constant: 0),
                    titleLabel.widthAnchor.constraint(equalTo: dataView.widthAnchor),
                    titleLabel.centerYAnchor.constraint(equalTo: dataView.centerYAnchor),
                    titleLabel.heightAnchor.constraint(equalTo: dataView.heightAnchor, multiplier: 0.3)
                    ])

            default:
                NSLayoutConstraint.activate([
                    titleLabel.centerXAnchor.constraint(equalTo: dataView.centerXAnchor, constant: 0),
                    titleLabel.widthAnchor.constraint(equalTo: dataView.widthAnchor),
                    titleLabel.centerYAnchor.constraint(equalTo: dataView.centerYAnchor),
                    titleLabel.heightAnchor.constraint(equalTo: dataView.heightAnchor, multiplier: 0.3)
                    ])
            }
        }
    }
    
    func setTitle(title: String) {
        self.titleLabel.text = title
    }
}
