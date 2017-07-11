import UIKit

class SettingsViewController: BaseTableViewController {
    
    weak var delegate: SettingsViewControllerDelegate?
    
    var sections = ["User", "Application"]
    var options = ["One", "Two"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SearchResultCell.self)
    }
}
