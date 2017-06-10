import UIKit

class SettingsViewController: UIViewController {
    
    weak var delegate: SettingsViewControllerDelegate?

    var settingsView: SettingsView!
    
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
        settingsView.backgroundColor = SettingsViewConstants.backgroundColor
        let model = SettingsViewModel(firstSettingOptionText: "OptionOne", secondSettingOptionText: "OptionTwo")
        view.addView(view: settingsView, type: .full)
        view = settingsView
        settingsView.configure(model: model)
        title = "Settings"
    }
}

