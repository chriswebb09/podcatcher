import UIKit

class SettingsViewController: BaseTableViewController {
    
    weak var delegate: SettingsViewControllerDelegate?
    
    var options = ["Log Out", "Clear Data", "Delete Account"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Settings"
        tableView.rowHeight = 100
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(SettingCell.self)
    }
}
