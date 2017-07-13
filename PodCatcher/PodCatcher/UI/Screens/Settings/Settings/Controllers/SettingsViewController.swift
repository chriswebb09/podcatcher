import UIKit

class SettingCell: UITableViewCell {
    
    static let reuseIdentifier = "SettingCell"
    
    var titleLabel: UILabel = {
        let title = UILabel()
        title.textColor = .black
        title.font = UIFont.systemFont(ofSize: 13, weight: UIFontWeightLight)
        title.textAlignment = .center
        title.numberOfLines = 0
        return title
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.layer.borderWidth = 1
        setup(titleLabel: titleLabel)
        selectionStyle = .none
    }
    
    func setup(titleLabel: UILabel) {
        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo:  contentView.centerYAnchor).isActive = true
        titleLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor).isActive = true
        titleLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.6).isActive = true
    }
}

extension SettingCell: Reusable {}

class SettingsViewController: BaseTableViewController {
    
    weak var delegate: SettingsViewControllerDelegate?
    
    var sections = ["User", "Application"]
    var options:[[String]] = [["Log Out", "User"], ["Clear Data", "Delete Account"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Settings"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SettingCell.self)
    }
}
