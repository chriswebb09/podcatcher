import UIKit

protocol PlaylistsCoordinator: ControllerCoordinator { }

extension PlaylistsCoordinator {
    
    func viewDidLoad(_ viewController: UIViewController) {
        let playlistsVC = viewController as! PlaylistsViewController
        playlistsVC.title = "Playlists"
//        playlistsVC.background.frame = UIScreen.main.bounds
//        playlistsVC.view.addSubview(playlistsVC.background)
//        playlistsVC.view.sendSubview(toBack: playlistsVC.background)
        playlistsVC.tableView.backgroundColor = .white
        playlistsVC.tableView.register(PlaylistCell.self, forCellReuseIdentifier: PlaylistCell.reuseIdentifier)
        playlistsVC.tableView.delegate = playlistsVC
        playlistsVC.rightButtonItem.tintColor = .white
        playlistsVC.navigationItem.setRightBarButton(playlistsVC.rightButtonItem, animated: false)
        playlistsVC.navigationItem.setLeftBarButton(playlistsVC.leftButtonItem, animated: false)
//        playlistsVC.playlistsDataSource.reloadData()
//        playlistsVC.tableView.dataSource = playlistsVC.playlistsDataSource
//        playlistsVC.playlistsDataSource.setIcon(icon: #imageLiteral(resourceName: "podcast-icon").withRenderingMode(.alwaysTemplate))
//        playlistsVC.playlistsDataSource.setText(text: "Create playlists with your favorite podcasts!")
//        if playlistsVC.playlistsDataSource.itemCount == 0 {
//            playlistsVC.navigationItem.leftBarButtonItem = nil
//        }
        
    }
}
