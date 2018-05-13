//
//  PlaylistsViewController.swift
//  Podcatch
//
//  Created by Christopher Webb-Orenstein on 2/3/18.
//  Copyright © 2018 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit
import CoreData

protocol SelectionViewControllerDelegate: class {
    func virtualObjectSelectionViewController(_ selectionViewController: SelectionViewController, didSelectObject: String)
    func virtualObjectSelectionViewController(_ selectionViewController: SelectionViewController, didDeselectObject: String)
}

class PlaylistsViewController: BaseTableViewController {
    
    weak var delegate: PlaylistsViewControllerDelegate?
    
    var audioPlayer: AudioFilePlayer!
    
    var miniPlayer: MiniPlayerViewController!
    
    var database: PlaylistDatabase! = PlaylistDatabase()
    
    enum PlaylistsInteractionMode {
        case add, edit
    }
    
    fileprivate let backgroundView = UIView()
    
    var playlistItems: [Playlist] = []
    
    var persistentContainer: NSPersistentContainer!
    
    lazy var managedContext: NSManagedObjectContext! = {
        let context = self.persistentContainer.viewContext
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return context
    }()
    
    lazy var fetchedResultsController:NSFetchedResultsController<Playlist> = {
        let fetchRequest:NSFetchRequest<Playlist> = Playlist.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        var controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedContext, sectionNameKeyPath: nil, cacheName: nil)
        do {
            try? controller.performFetch()
        }
        return controller
    }()
    
    var mode: PlaylistsInteractionMode = .add
    
    var playlists: [Playlist] = [] {
        didSet {
            DispatchQueue.main.async {
                if self.playlists.count <= 0 {
                    self.leftButtonItem = nil
                } else {
                    self.leftButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(self.edit))
                }
            }
        }
    }
    
    var playerContainer: UIView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        edgesForExtendedLayout = []
        tableView.register(PlaylistCell.self, forCellReuseIdentifier: PlaylistCell.reuseIdentifier)
        ApplicationStyling.setupUI()
        setupPlayerContainer()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            self.playlistItems = self.database.fetchPlaylists()
            self.tableView.reloadData()
            
            if self.playlistItems.count <= 0 {
                self.leftButtonItem = nil
            } else {
                self.leftButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(self.edit))
            }
            //self.delegate?.updateNavItems()
        }
    }
    
    func setupPlayerContainer() {
        if #available(iOS 10, *) {
            view.addSubview(playerContainer)
        } else {
            view.add(playerContainer)
        }
        playerContainer.translatesAutoresizingMaskIntoConstraints = false
        playerContainer.bottomAnchor.constrainEqual(view.bottomAnchor)
        playerContainer.widthAnchor.constrainEqual(view.widthAnchor)
        playerContainer.centerXAnchor.constrainEqual(view.centerXAnchor)
        
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 480, 960, 1136:
                playerContainer.heightAnchor.constraint(equalToConstant: 60).isActive = true
            case 1334, 2208:
                playerContainer.heightAnchor.constraint(equalToConstant: 68).isActive = true
            default:
                playerContainer.heightAnchor.constraint(equalToConstant: 68).isActive = true
            }
        }
    }
    
    func setupTableView() {
        tableView.register(PlaylistCell.self, forCellReuseIdentifier: PlaylistCell.reuseIdentifier)
        rightButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "plus-red").withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(addPlaylist))
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UIScreen.main.bounds.height / 8
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.bottomAnchor.constraint(equalTo: playerContainer.bottomAnchor, constant: 0).isActive = true
        tableView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: 0).isActive = true
        tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        emptyView = InformationView(data: "Create playlists with episodes from your favorite podcasts.", icon: #imageLiteral(resourceName: "play-icon").withRenderingMode(.alwaysTemplate))
        tableView.reloadData()
    }
    
    @objc func addPlaylist() {
        presentAlert()
    }
    
    func setMiniPlayer(miniPlayer: MiniPlayerViewController) {
        delegate?.setMiniPlayer(miniPlayer: miniPlayer)
    }
    
    @objc func edit() {
        mode = mode == .edit ? .add : .edit
        print(mode)
        DispatchQueue.main.async {
            switch self.mode {
            case .edit:
                self.leftButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.edit))
            case .add:
                self.leftButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(self.edit))
            }
           // self.delegate?.updateNavItems()
            self.playlistItems = self.database.fetchPlaylists()
            self.tableView.reloadData()
        }
    }
    
    func createPlaylist(title: String) {
        database.insertPlaylist(title: title)
        database.save()
    }
    
    func presentAlert() {
        let alertController = UIAlertController(title: "New playlist:", message: "Pick a name for your new playlist:", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "Done", style: .default) { (_) in
            if let field = alertController.textFields?[0] {
                guard let text = field.text else { return }
                
                self.createPlaylist(title: text)
                //self.delegate?.createPlaylist(title: text)
                self.playlistItems = self.database.fetchPlaylists()
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                self.delegate?.updateNavItems()
            } else {
                // user did not fill field
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        alertController.addTextField { (textField) in
            textField.placeholder = "Playlist"
        }
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.async {
            self.playlistItems = self.database.fetchPlaylists()
            self.tableView.reloadData()
            if self.playlistItems.count <= 0 {
                self.leftButtonItem = nil
            } else {
                self.leftButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(self.edit))
            }
            self.delegate?.updateNavItems()
        }
    }
}

extension PlaylistsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if playlistItems.count  > 0 {
            tableView.backgroundView = backgroundView
            tableView.backgroundView?.layoutSubviews()
        } else {
            emptyView = InformationView(data: "Create playlists with episodes from your favorite podcasts.", icon:  #imageLiteral(resourceName: "play"))
            emptyView.setLabel(text: "Create playlists with episodes from your favorite podcasts.")
            emptyView.setIcon(icon: #imageLiteral(resourceName: "play-icon"))
            emptyView.frame = tableView.frame
            tableView.backgroundView = emptyView
        }
        if playlistItems.count >= 0 {
            return playlistItems.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PlaylistCell.reuseIdentifier, for: indexPath) as! PlaylistCell
        var cellMode: PlaylistCellMode = .select
        cellMode = mode == .add ? .select : .delete
        if let episodes = playlistItems[indexPath.row].playlistEpisodes as? Set<Episode>, episodes.count > 0 {
            for (_, _) in episodes.enumerated() {
                let viewModel = PlaylistCellViewModel(podcast: playlistItems[indexPath.row])
                cell.configureWith(model: viewModel)
            }
        }  else {
            if let name = playlistItems[indexPath.row].name, let episodes = playlistItems[indexPath.row].playlistEpisodes {
                cell.configure(image: #imageLiteral(resourceName: "light-placehoder-2"), title: name.capitalized, subtitle: "Episodes: \(episodes.count)", mode: cellMode)
            } else {
                cell.configure(image: #imageLiteral(resourceName: "light-placehoder-2"), title: "temp", subtitle: "Episodes: Unknown", mode: cellMode)
            }
        }
        return cell
    }
}

extension PlaylistsViewController: UITableViewDelegate {
    
    func playButton(tapped: Bool) {
//        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
//            appDelegate.play()
//        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch mode {
        case .add:
            let playlist = playlistItems[indexPath.row]
            let playlistVC = PlaylistViewController()
            playlistVC.persistentContainer = persistentContainer
            playlistVC.playlist = playlist
            playlistVC.name = playlist.name!
            playlistVC.playlistId = playlist.playlistId
            playlistVC.miniPlayer = self.miniPlayer
            navigationController?.pushViewController(playlistVC, animated: false)
            navigationController?.title = playlist.name!
            navigationController?.navigationItem.title = "TEST"
        case .edit:
            do {
                tableView.reloadData()
                playlistItems = database.fetchPlaylists()
                // let playlist = NSEntityDescription.entity(forEntityName: "Playlist", in: self.persistentContainer.viewContext)!
                
                deletePlaylistWith(id: playlistItems[indexPath.row].playlistId!)
                do {
                    try self.persistentContainer.viewContext.save()
                    DispatchQueue.main.async {
                        self.playlistItems = self.database.fetchPlaylists()
                        tableView.deleteRows(at: [indexPath], with: .fade)
                        
                    }
                } catch let error {
                    print(error.localizedDescription)
                }
            }
        }
        self.tableView.reloadData()
    }
    
    func deletePlaylistWith(id: String) {
        persistentContainer.performBackgroundTask { privateManagedObjectContext in
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Playlist")
            let predicate = NSPredicate(format: "playlistId == %@", id)
            request.predicate = predicate
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
            deleteRequest.resultType = .resultTypeObjectIDs
            do {
                let result = try privateManagedObjectContext.execute(deleteRequest) as? NSBatchDeleteResult
                guard let objectIDs = result?.result as? [NSManagedObjectID] else { return }
                let changes = [NSUpdatedObjectsKey: objectIDs]
                NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [self.persistentContainer.viewContext])
            } catch {
                fatalError("Failed to execute request: \(error)")
            }
        }
    }
}

protocol PlaylistsViewControllerOutput {
    
}


protocol PlaylistsViewControllerInput {
    func didAssignToPlaylist(episode: Episode)
}


