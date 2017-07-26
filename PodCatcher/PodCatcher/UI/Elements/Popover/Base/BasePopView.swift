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
    
    private func sharedLayout(view: UIView) {
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.topAnchor.constraint(equalTo: topAnchor).isActive = true
        view.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        view.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.25).isActive = true
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

class BasePopoverAlert: UIView {
    
    let containerView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = UIColor.black
        containerView.layer.opacity = BasePopoverAlertConstants.containerOpacity
        return containerView
    }()
    
    func showPopView(viewController: UIViewController) {
        containerView.isHidden = false
        containerView.frame = UIScreen.main.bounds
        containerView.center = CGPoint(x: BasePopoverAlertConstants.popViewX, y: BasePopoverAlertConstants.popViewY)
        viewController.view.addSubview(containerView)
    }
    
    func hidePopView(viewController: UIViewController){
        viewController.view.sendSubview(toBack: containerView)
        containerView.isHidden = true
    }
    
    func configureContainer() {
        containerView.layer.opacity = 0
    }
}
