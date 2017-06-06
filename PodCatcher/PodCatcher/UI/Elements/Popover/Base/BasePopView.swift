import UIKit

class BasePopView: UIView {
    
    // View with title ect.
    
    private let headBanner: UIView = {
        let banner = UIView()
        banner.backgroundColor = UIColor.black
        return banner
    }()
    
    private var alertLabel: UILabel = {
        let searchLabel = UILabel()
        searchLabel.textColor = UIColor.white
        searchLabel.text = "Notification"
        searchLabel.textAlignment = .center
        return searchLabel
    }()
    
    private func setupHeadBanner(headBanner: UIView) {
        addSubview(headBanner)
        headBanner.translatesAutoresizingMaskIntoConstraints = false
        headBanner.topAnchor.constraint(equalTo: topAnchor).isActive = true
        headBanner.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        headBanner.heightAnchor.constraint(equalTo: heightAnchor, multiplier: BasePopConstants.heightMultiplier).isActive = true
        headBanner.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
    }
    
    private func setupAlertLabel(label: UILabel) {
        addSubview(alertLabel)
        alertLabel.translatesAutoresizingMaskIntoConstraints = false
        alertLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        alertLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        alertLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: BasePopConstants.heightMultiplier).isActive = true
        alertLabel.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
    }
    
    private func setupConstraints() {
        setupHeadBanner(headBanner: headBanner)
        setupAlertLabel(label: alertLabel)
    }
}
