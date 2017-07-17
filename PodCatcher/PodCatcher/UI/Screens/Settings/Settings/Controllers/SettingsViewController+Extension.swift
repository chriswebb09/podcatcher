import UIKit
import Firebase

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
    
    func onTap() {
        print("tapped")
    }
    
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
        guard let user = Auth.auth().currentUser else { return }
        user.delete { error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                self.delegate?.guestUserSignIn(tapped: true)
            }
        }
    }
}
