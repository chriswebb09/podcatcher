import UIKit

class SettingsViewController: UIViewController {
    
    var settingsView: SettingsView!
    
    weak var delegate: SettingsViewControllerDelegate?
    
    init(settingsView: SettingsView) {
        self.settingsView = settingsView
        super.init(nibName: nil, bundle: nil)
        self.settingsView.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        edgesForExtendedLayout = []
        settingsView.backgroundColor = UIColor(red:0.10, green:0.09, blue:0.12, alpha:1.0)
        settingsView.layoutSubviews()
        view.addView(view: settingsView, type: .full)
        view = settingsView
        title = "Settings"
    }
}

extension SettingsViewController: SettingsViewDelegate {
    
    func settingOneTapped() {
        print("One")
        delegate?.settingOneTapped(tapped: true)
    }
    
    func settingTwoTapped() {
        print("two")
        delegate?.settingTwoTapped(tapped: true)
    }
}
