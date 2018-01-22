import UIKit
import CoreData

final class PlaylistsViewController: BaseTableViewController {
    
    weak var podcastDelegate: PodcastDelegate?
    weak var delegate: PlaylistsViewControllerDelegate?
    
    var coordinator: PlaylistsCoordinator?
    
    var reference: PlaylistsReference = .checkList
    var tap: UIGestureRecognizer!
    private var entryPop: EntryPopover = EntryPopover()
    var mode: PlaylistsInteractionMode = .add
    var casterItemToSave: CasterSearchResult!
    var index: Int!
    var item: CasterSearchResult!
    
    var managedContext: NSManagedObjectContext! {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        let context = appDelegate.persistentContainer.viewContext
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return context
    }
    
    lazy var fetchedResultsController:NSFetchedResultsController<PodcastPlaylist> = {
        let fetchRequest:NSFetchRequest<PodcastPlaylist> = PodcastPlaylist.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "playlistId", ascending: true)]
        var controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedContext, sectionNameKeyPath: nil, cacheName: nil)
        do {
            try? controller.performFetch()
        }
        return controller
    }()
    
    var background = UIView()
    
    var playlistsDataSource: TableViewDataSource<PlaylistsViewController>!
    let persistentContainer = NSPersistentContainer(name: "PodCatcher")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(PlaylistCell.self)
        initialize()
        edgesForExtendedLayout = []
    }
    
    func initialize() {
        entryPop.delegate = self
        playlistsDataSource = TableViewDataSource(tableView: tableView, identifier: PlaylistCell.reuseIdentifier, fetchedResultsController: fetchedResultsController, delegate: self)
        leftButtonItem  = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(edit))
        rightButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "plus-red").withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(addPlaylist))
        background.frame = UIScreen.main.bounds
        view.addSubview(background)
        view.sendSubview(toBack: background)
        tableView.backgroundColor = .white
        tableView.register(PlaylistCell.self, forCellReuseIdentifier: PlaylistCell.reuseIdentifier)
        tableView.delegate = self
        rightButtonItem.tintColor = .white
        navigationItem.setRightBarButton(rightButtonItem, animated: false)
        navigationItem.setLeftBarButton(leftButtonItem, animated: false)
        playlistsDataSource.reloadData()
        tableView.dataSource = playlistsDataSource
        playlistsDataSource.setIcon(icon: #imageLiteral(resourceName: "podcast-icon").withRenderingMode(.alwaysTemplate))
        playlistsDataSource.setText(text: "Create playlists with your favorite podcasts!")
        if playlistsDataSource.itemCount == 0 {
            navigationItem.leftBarButtonItem = nil
        }
//        coordinator?.viewDidLoad(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavbar()
    }
    
    private func setupNavbar() {
        DispatchQueue.main.async {
            let backImage = #imageLiteral(resourceName: "back").withRenderingMode(.alwaysTemplate)
            self.navigationController?.navigationBar.backIndicatorImage = backImage
            self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = backImage
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        mode = .add
    }
    
    @objc func edit() {
        mode = mode == .edit ? .add : .edit
        if navigationItem.leftBarButtonItem != nil {
            leftButtonItem.title = mode == .edit ? "Done" : "Edit"
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

extension PlaylistsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.height / 7.5
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch mode {
        case .edit:
            editMode(indexPath: indexPath)
        case .add:
            addFor(indexPath: indexPath)
        }
    }
    
    func addFor(indexPath: IndexPath) {
        guard let text = fetchedResultsController.object(at: indexPath).playlistId else { return }
        switch reference {
        case .addPodcast:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: PlaylistCell.reuseIdentifier, for: indexPath) as! PlaylistCell
            let podcastItem = PodcastPlaylistItem(context: fetchedResultsController.managedObjectContext)
            
            podcastItem.audioUrl = item.episodes[index].audioUrlSting
            podcastItem.artistFeedUrl = item.feedUrl
            
            let isoDate = item.episodes[index].date
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            if let date = dateFormatter.date(from:isoDate) {
                let calendar = Calendar.current
                let components = calendar.dateComponents([.year, .month, .day, .hour], from: date)
                let finalDate = calendar.date(from:components)! as NSDate
                podcastItem.date = finalDate
            }
            
            podcastItem.artistId = item.artistId
            podcastItem.playlistId = cell.titleLabel.text!
            podcastItem.duration = item.episodes[index].duration
            podcastItem.artistName = item.podcastArtist
            podcastItem.stringDate = item.episodes[index].date
            podcastItem.artworkUrl = item.podcastArtUrlString
            podcastItem.episodeTitle = item.episodes[index].title
            podcastItem.episodeDescription = item.episodes[index].description
            podcastItem.tags = item.nsTags()
            
            if let urlString = item.podcastArtUrlString, let url = URL(string: urlString) {
                UIImage.downloadImage(url: url) { image in
                    let podcastArtImageData = UIImageJPEGRepresentation(image, 1)
                    if let podcastArtImageData = podcastArtImageData {
                        podcastItem.artwork = NSData.init(data: podcastArtImageData)
                    }
                }
            }
            
            let playlist = fetchedResultsController.object(at: indexPath)
            podcastItem.playlist = playlist
            playlist.addToPodcast(podcastItem)
            
            if let context = podcastItem.managedObjectContext {
                
                context.performAndWait() {
                    do {
                        try context.save()
                    } catch let error {
                        print(error.localizedDescription)
                    }
                }
            }
            
        case .checkList:
            guard text != "" else { return }
            addNewPlaylist(text: text, from: indexPath)
        }
        reference = .checkList
    }
    
    
    func add(text: String) {
        reference = .checkList
        DispatchQueue.main.async { self.playlistsDataSource.reloadData() }
        delegate?.didAssignPlaylist(with: text)
    }
    
    func addToPlaylist(with name: String) {
        guard name != "" else { return  }
        reference = .checkList
        DispatchQueue.main.async {
            self.playlistsDataSource.reloadData()
        }
    }
    
    func addNewPlaylist(text: String, from indexPath: IndexPath) {
        let casts = fetchedResultsController.object(at: indexPath)
        let playlist = PlaylistViewController(index: 0, player: AudioFilePlayer(), playlist: casts)
        playlist.playlistId = text
        delegate?.playlistSelected(for: casts)
    }
    
    func editMode(indexPath: IndexPath) {
        guard let title = fetchedResultsController.object(at: indexPath).playlistName else { return }
        DispatchQueue.main.async {
            let actionSheetController: UIAlertController = UIAlertController(title: "Are you sure?", message: "Pressing okay will delete \(title).", preferredStyle: .alert)
            let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action in
                actionSheetController.dismiss(animated: false, completion: nil)
            }
            let okayAction: UIAlertAction =  UIAlertAction(title: "Okay", style: .destructive) { action in
                self.removeFor(indexPath: indexPath)
            }
            actionSheetController.addAction(cancelAction)
            actionSheetController.addAction(okayAction)
            self.present(actionSheetController, animated: true, completion: nil)
        }
    }
    
    func removeFor(indexPath: IndexPath) {
        
        let item = fetchedResultsController.object(at: indexPath)
        
        guard let podcast = item.podcast else { return }
        
        for (_, podcast) in (podcast.enumerated()) {
            if let pod = podcast as? PodcastPlaylistItem, let audioUrl = pod.audioUrl {
                LocalStorageManager.deleteSavedItem(itemUrlString: audioUrl)
            }
        }
        
        managedContext.delete(item)
        
        do {
            try managedContext.save()
            playlistsDataSource.reloadData()
        } catch let error {
            print(error.localizedDescription)
        }
        
        if let count = fetchedResultsController.fetchedObjects?.count {
            if count == 0 {
                self.mode = .add
                self.leftButtonItem.title = "Edit"
            }
            if self.playlistsDataSource.itemCount == 0 {
                DispatchQueue.main.async {
                    self.navigationItem.leftBarButtonItem = nil
                }
            }
        }
    }
}

extension PlaylistsViewController: EntryPopoverDelegate {
    
    func userDidEnterPlaylistName(name: String) {
        guard name != "" else { return }
        var playlistDataStack = PlaylistsCoreData()
        playlistDataStack.save(name: name, uid: "none")
        playlistsDataSource.reloadData()
        if playlistsDataSource.itemCount > 0 {
            navigationItem.leftBarButtonItem = leftButtonItem
        }
        tableView.reloadData()
        playlistsDataSource.reloadData()
    }
    
    @objc func addPlaylist() {
        UIView.animate(withDuration: 0.05) {
            self.entryPop.showPopView(viewController: self)
            self.entryPop.popView.isHidden = false
        }
        tap = UITapGestureRecognizer(target: self, action: #selector(hidePop))
        view.addGestureRecognizer(tap)
        entryPop.popView.doneButton.addTarget(self, action: #selector(hidePop), for: .touchUpInside)
    }
    
    @objc func hidePop() {
        entryPop.hidePopView(viewController: self)
        view.removeGestureRecognizer(tap)
        view.endEditing(true)
    }
}

extension PlaylistsViewController: TableViewDataSourceDelegate {
    
    typealias Cell = PlaylistCell
    typealias Object = PodcastPlaylist
    
    func configure(_ cell: PlaylistCell, for object: PodcastPlaylist) {
        
        var cellMode: PlaylistCellMode = .select
        
        cellMode = mode == .add ? .select : .delete
        
        if let podcast = object.podcast as? Set<PodcastPlaylistItem>, podcast.count > 0 {
            
            for (index, pod) in podcast.enumerated() {
                if index == 0 {
                    if let data = pod.artwork, let artworkImage = UIImage(data: Data.init(referencing: data)), let title = object.playlistName {
                        cell.configure(image: artworkImage, title: title, subtitle: "Episodes: \(podcast.count)", mode: cellMode)
                    }
                }
            }
            
        } else {
            
            if let name = object.playlistName, let count = object.podcast?.count {
                cell.configure(image: #imageLiteral(resourceName: "light-placehoder-2"), title: name, subtitle: "Episodes: \(count)", mode: cellMode)
            } else {
                cell.configure(image: #imageLiteral(resourceName: "light-placehoder-2"), title: "temp", subtitle: "Episodes: Unknown", mode: cellMode)
            }
        }
    }
}
