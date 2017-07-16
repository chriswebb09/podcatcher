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
        if label == "Log Out" {
            delegate?.guestUserSignIn(tapped: true)
        } else if label == "Delete Account" {
            deleteUser()
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
