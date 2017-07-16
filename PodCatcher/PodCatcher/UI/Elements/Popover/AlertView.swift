import UIKit

struct Constants {
    public struct Alert {
        public struct CancelButton {
            public static let cancelButtonWidth:CGFloat = 0.5
            public static let cancelButtonColor: UIColor = UIColor(red:0.88, green:0.35, blue:0.35, alpha:1.0)
        }
    }
    
    enum Color {
        case mainColor, backgroundColor, buttonColor, tableViewBackgroundColor
        
        var setColor: UIColor {
            switch self {
            case .mainColor:
                return UIColor(red:0.41, green:0.72, blue:0.90, alpha:1.0)
            case .backgroundColor:
                return UIColor(red:0.21, green:0.22, blue:0.24, alpha:1.0)
            case .buttonColor:
                return UIColor(red:0.10, green:0.71, blue:1.00, alpha:1.0)
            case .tableViewBackgroundColor:
                return UIColor(red:0.92, green:0.92, blue:0.92, alpha:1.0)
            }
        }
    }
    
    public struct Font {
        public static let fontNormal = UIFont(name: "HelveticaNeue-Light", size: 18)
        public static let fontSmall = UIFont(name: "HelveticaNeue-Light", size: 12)
        public static let fontMedium = UIFont(name: "HelveticaNeue-Light", size: 16)
        public static let fontLarge = UIFont(name: "HelveticaNeue-Thin", size: 22)
        
        public static let bolderFontSmall = UIFont(name: "HelveticaNeue", size: 12)
        public static let bolderFontMediumSmall = UIFont(name: "HelveticaNeue", size: 14)
        public static let bolderFontMedium = UIFont(name: "HelveticaNeue", size: 16)
        public static let bolderFontMediumLarge = UIFont(name: "HelveticaNeue", size: 20)
        public static let bolderFontLarge = UIFont(name: "HelveticaNeue", size: 22)
        public static let bolderFontNormal = UIFont(name: "HelveticaNeue", size: 18)
    }
    
    public struct Dimension {
        static let screenHeight = UIScreen.main.bounds.height
        static let screenWidth = UIScreen.main.bounds.width
        public static let mainWidth:CGFloat = 0.4
        public static let mainOffset:CGFloat = 30
        public static let buttonHeight:CGFloat = 0.07
        public static let cellButtonHeight:CGFloat = 0.03
        public static let saveButtonHeight:CGFloat = 0.05
        // static let buttonHeight = CGFloat(0.009)
        public static let topOffset:CGFloat = 10
        public static let bottomOffset:CGFloat = -10
        public static let settingsOffset:CGFloat = 0.05
        public static let mainHeight:CGFloat = 0.2
        public static let fieldHeight: CGFloat = 0.75
        public static let height: CGFloat = 0.5
        public static let width: CGFloat = 0.85
    }
}
enum ButtonType {
    
    case login(title:String), system(title:String, color: UIColor), tag(title:String, color:UIColor, tag: Int, index: IndexPath)
    
    fileprivate func setupLoginButton(with title:String) -> UIButton {
        let button = UIButton()
        button.backgroundColor = Constants.Color.mainColor.setColor
        button.setAttributedTitle( NSAttributedString(string: title, attributes: [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: Constants.Font.fontNormal!]), for: .normal)
        configureButton(button: button)
        return button
    }
    
    fileprivate func configureButton(button:UIButton) {
        button.layer.cornerRadius = 2
        button.layer.borderWidth = 1
    }
    
    fileprivate func setupSystemButton(with title:String, color: UIColor?) -> UIButton {
        let button = TagButton()
        let buttonColor = color ?? .black
        button.setAttributedTitle( NSAttributedString(string: title, attributes: [NSForegroundColorAttributeName: buttonColor,
                                                                                  NSFontAttributeName: Constants.Font.fontNormal!]), for: .normal)
        configureButton(button: button)
        return button as UIButton
    }
    
    fileprivate func setupTagButton(with title:String, color: UIColor?, tag: Int, index: IndexPath) -> TagButton {
        let button = TagButton()
        let buttonColor = color ?? .black
        button.setAttributedTitle( NSAttributedString(string: title,
                                                      attributes: [NSForegroundColorAttributeName: buttonColor,
                                                                   NSFontAttributeName: Constants.Font.fontNormal!]), for: .normal)
        configureButton(button: button)
        button.buttonTag = tag
        button.index = index
        return button
    }
    
    public var newButton: UIButton {
        switch self {
        case let .login(title):
            return setupLoginButton(with: title)
        case let .system(title, color):
            return setupSystemButton(with: title, color: color)
        default:
            return UIButton()
        }
    }
    
    public var tagButton: TagButton {
        switch self {
        case let .tag(title: title, color: color, tag: tag, index:index):
            return setupTagButton(with: title, color: color, tag: tag, index:index)
        default:
            return TagButton()
        }
    }
}

final class TagButton: UIButton {
    var buttonTag: Int?
    var index: IndexPath?
}

final class AlertView: UIView {
    
    var headBanner: UIView = {
        let banner = UIView()
        banner.backgroundColor = .lightGray
        return banner
    }()
    
    var cancelButton: UIButton = {
        var button = ButtonType.system(title: "Cancel", color: .white).newButton
        button.backgroundColor = Constants.Alert.CancelButton.cancelButtonColor
        button.layer.cornerRadius = 0
        return button
    }()
    
    var doneButton: UIButton = {
        var button = ButtonType.system(title: "Add", color: .white).newButton
        button.backgroundColor = Constants.Color.mainColor.setColor
        button.layer.cornerRadius = 0
        return button
    }()
    
    var resultLabel: UILabel = {
        let searchLabel = UILabel()
        searchLabel.text = "Results"
        searchLabel.textColor = .black
        searchLabel.textAlignment = .center
        searchLabel.font = Constants.Font.fontNormal
        return searchLabel
    }()
    
    var alertLabel: UILabel = {
        let searchLabel = UILabel()
        searchLabel.textColor = .black
        searchLabel.textAlignment = .center
        searchLabel.text = "Find Your Friends"
        searchLabel.font = Constants.Font.fontNormal
        return searchLabel
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupConstraints()
        backgroundColor = .white
    }
    
}

extension AlertView {
    
    fileprivate func configureConstaints(label: UILabel) {
        label.translatesAutoresizingMaskIntoConstraints = false
        label.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        label.heightAnchor.constraint(equalTo: heightAnchor, multiplier: Constants.Dimension.mainHeight).isActive = true
    }
    
    fileprivate func addSubviews() {
        addSubview(doneButton)
        addSubview(alertLabel)
        addSubview(headBanner)
        addSubview(resultLabel)
        addSubview(cancelButton)
    }
    
    fileprivate func configs() {
        configureConstaints(label: alertLabel)
        configureConstaints(label: resultLabel)
    }
    
    private func addHeaderBanner() {
        headBanner.translatesAutoresizingMaskIntoConstraints = false
        headBanner.topAnchor.constraint(equalTo: topAnchor).isActive = true
        headBanner.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        headBanner.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        headBanner.heightAnchor.constraint(equalTo: heightAnchor, multiplier: Constants.Dimension.mainHeight).isActive = true
    }
    
    private func addDoneButton() {
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        doneButton.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        doneButton.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        doneButton.heightAnchor.constraint(equalTo: heightAnchor, multiplier: Constants.Dimension.mainHeight).isActive = true
        doneButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: Constants.Alert.CancelButton.cancelButtonWidth).isActive = true
    }
    
    private func addCancelButton() {
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        cancelButton.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        cancelButton.heightAnchor.constraint(equalTo: heightAnchor, multiplier: Constants.Dimension.mainHeight).isActive = true
        cancelButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: Constants.Alert.CancelButton.cancelButtonWidth).isActive = true
    }
    
    private func addResultLabel() {
        resultLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        resultLabel.topAnchor.constraint(equalTo: topAnchor, constant: bounds.height / 3).isActive = true
    }
    
    private func addAlertLabel() {
        alertLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        alertLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
    
    fileprivate func setupConstraints() {
        addSubviews()
        configs()
        addHeaderBanner()
        addAlertLabel()
        addResultLabel()
        addCancelButton()
        addDoneButton()
    }
}
