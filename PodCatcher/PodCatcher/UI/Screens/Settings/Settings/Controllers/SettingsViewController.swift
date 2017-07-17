import UIKit

class SettingsViewController: BaseTableViewController {
    
    weak var delegate: SettingsViewControllerDelegate?
    var dataSource: BaseMediaControllerDataSource!
    var options = ["Log Out", "Delete Account"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Settings"
        if dataSource.user == nil {
            self.options =  ["Log Into Account"]
        }
        tableView.rowHeight = 100
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(SettingCell.self)
        
    }
}
