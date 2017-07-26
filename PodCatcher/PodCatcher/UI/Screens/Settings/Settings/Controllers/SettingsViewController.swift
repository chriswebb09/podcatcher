import UIKit

protocol SettingsViewControllerDelegate: class {
    func guestUserSignIn(tapped: Bool)
}

protocol SettingCellDelegate: class {
    func cellTapped(with label: String)
}

class SettingsViewController: BaseTableViewController {
    
    weak var delegate: SettingsViewControllerDelegate?
    var dataSource: BaseMediaControllerDataSource!
    var options = ["Log Out", "Delete Account"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Settings"
        tableView.rowHeight = 100
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(SettingCell.self)
    }
}

extension SettingsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
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
            delegate?.guestUserSignIn(tapped: true)
        } else if label == "Delete Account" {
            let actionSheetController: UIAlertController = UIAlertController(title: "Please Confirm", message: "Are you sure you want to delete your account?", preferredStyle: .alert)
            let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action in
                return
            }
            let deleteAction: UIAlertAction = UIAlertAction(title: "Delete Account", style: .destructive) { action in
                self.deleteUser()
            }
            actionSheetController.addAction(cancelAction)
            actionSheetController.addAction(deleteAction)
            self.present(actionSheetController, animated: true, completion: nil)
        }
    }
    
    func deleteUser() {
        
    }
}
