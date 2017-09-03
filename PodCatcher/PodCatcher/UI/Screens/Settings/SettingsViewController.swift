import UIKit

struct SettingsViewControllerConstants {
    static let rowHeight: CGFloat = 100
}


final class SettingsViewController: BaseTableViewController {
    
    weak var delegate: SettingsViewControllerDelegate?
   
    var dataSource: BaseMediaControllerDataSource!
    
    var options = ["Log Out"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
