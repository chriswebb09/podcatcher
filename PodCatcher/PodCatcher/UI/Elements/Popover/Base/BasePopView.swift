import UIKit

protocol PopviewDelegate: class {
    
}

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
    
    private func sharedLayout(view: UIView) {
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.topAnchor.constraint(equalTo: topAnchor).isActive = true
        view.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        view.heightAnchor.constraint(equalTo: heightAnchor, multiplier: BasePopConstants.heightMultiplier).isActive = true
        view.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
    }
    
    private func setupHeadBanner(headBanner: UIView) {
        sharedLayout(view: headBanner)
    }
    
    private func setupAlertLabel(label: UILabel) {
        sharedLayout(view: label)
    }
    
    private func setupConstraints() {
        setupHeadBanner(headBanner: headBanner)
        setupAlertLabel(label: alertLabel)
    }
}
