import UIKit

extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        dump(self)
        print(options[indexPath.row])
       // delegate?.guestUserSignIn(tapped: true)
    }
}

extension SettingsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as SettingCell
        cell.delegate = self
        let item = options[indexPath.row]
        cell.titleLabel.text = item
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
        }
    }
    
}
