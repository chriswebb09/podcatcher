import UIKit

class SettingsViewController: UIViewController {
    
    weak var delegate: SettingsViewControllerDelegate?
    
    var dataSource: BaseMediaControllerDataSource

    var settingsView: SettingsView!
    
    init(settingsView: SettingsView, dataSource: BaseMediaControllerDataSource) {
        self.settingsView = settingsView
        self.dataSource = dataSource
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
        let model = SettingsViewModel(firstSettingOptionText: "Favorite Podcasts", secondSettingOptionText: "OptionTwo")
        view.addView(view: settingsView, type: .full)
        view = settingsView
        settingsView.configure(model: model)
        title = "Settings"
    }
}

