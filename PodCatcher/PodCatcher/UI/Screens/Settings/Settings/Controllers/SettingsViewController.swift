import UIKit

class SettingsViewController: BaseTableViewController {
    
    weak var delegate: SettingsViewControllerDelegate?
    
    var sections = ["Application"]
    var options:[[String]] = [["Log Out"], ["Clear Data", "Delete Account"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Settings"
        tableView.delegate = self
        tableView.rowHeight = 100
        tableView.dataSource = self
        tableView.register(SettingCell.self)
    }
}
