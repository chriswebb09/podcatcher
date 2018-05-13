import UIKit

final class SettingsViewController: BaseTableViewController {
    
    weak var delegate: SettingsViewControllerDelegate?
   
    var dataSource: BaseMediaControllerDataSource!
    
    var options = ["Log Out"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        edgesForExtendedLayout = []
        initialize()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.indexPathsForSelectedRows?.forEach {
            tableView.deselectRow(at: $0, animated: true)
        }
    }
    
    func initialize() {
        title = "Settings"
        tableView.rowHeight = SettingsViewControllerConstants.rowHeight
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(SettingCell.self)
    }
}

extension SettingsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return SettingsViewControllerConstants.rowHeight
    }
}

extension SettingsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as SettingCell
        cell.delegate = self
        cell.titleLabel.text = options[indexPath.row]
        return cell
    }
}

extension SettingsViewController: SettingCellDelegate {
    
    func cellTapped(with label: String) {
        if label == "Log Out" || label == "Log Into Account" {
            delegate?.guestUserSignIn(true)
        }
    }
}
