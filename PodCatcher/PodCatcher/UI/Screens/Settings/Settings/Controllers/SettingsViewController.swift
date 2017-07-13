import UIKit

class SettingsViewController: BaseTableViewController {
    
    weak var delegate: SettingsViewControllerDelegate?
    
    var sections = ["User", "Application"]
    var options:[[String]] = [["Log Out", "User"], ["Clear Data", "Delete Account"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Settings"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SearchResultCell.self)
    }
}
