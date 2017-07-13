import UIKit

class BaseTableViewController: BaseViewController {
    
    var tableView: UITableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        edgesForExtendedLayout = []
     //   guard let navBar = navigationController?.navigationBar else { return }
        guard let tabBar  = tabBarController?.tabBar else { return }
        tableView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: view.frame.height - tabBar.frame.height)
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.layoutMargins = UIEdgeInsets.zero
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.separatorStyle = .singleLineEtched
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = UIScreen.main.bounds.height / 4
    }
}
