import UIKit

class PlaylistsViewController: BaseViewController {
    
    var tableView: UITableView = UITableView()
    
    var dataSource = SearchControllerDataSource() {
        didSet {
            print("data source created")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let tabBar  = tabBarController?.tabBar else { return }
        tableView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: view.frame.height - tabBar.frame.height)
        tableView.dataSource = dataSource
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.register(SearchResultCell.self, forCellReuseIdentifier: SearchResultCell.reuseIdentifier)
        tableView.layoutMargins = UIEdgeInsets.zero
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.separatorStyle = .singleLineEtched
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = UIScreen.main.bounds.height / 4
        tableView.delegate = self
        rightButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "plus-red").withRenderingMode(.alwaysTemplate), style: .done, target: self, action: #selector(addPlaylist))
        rightButtonItem.tintColor = Colors.brightHighlight
    }
    
    func addPlaylist() {
        print(addPlaylist())
    }
}

extension PlaylistsViewController: UITableViewDelegate {
    
}
