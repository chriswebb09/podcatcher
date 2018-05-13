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


protocol PlaylistsViewControllerDelegate: class {
    func didSelect(title: String)
    func updateNavItems()
    func createPlaylist(title: String)
    func setMiniPlayer(miniPlayer: MiniPlayerViewController)
    // func updateNavTitle()
}


class PlaylistCellViewModel: CellViewModel {
    
    var mainImage: UIImage! {
        didSet {
            podcastImage = mainImage
        }
    }
    
    var titleText: String! {
        didSet {
            playlistName = titleText
        }
    }
    
    var playlistName: String!
    var podcastImage: UIImage!
    var playlist: Playlist
    
    weak var delegate: TopPodcastCellViewModelDelegate?
    
    init(podcast: Playlist) {
        self.playlist = podcast
    }
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


final class PlaylistCell: UITableViewCell, Reusable {
    
   // static let reuseIdentifier = "PlaylistCell"
    
    var mode: PlaylistCellMode = .select {
        didSet {
            switch mode {
            case .select:
                deleteImageView.alpha = 1
                let image = #imageLiteral(resourceName: "circle-play").withRenderingMode(.alwaysTemplate)
                deleteImageView.image = image
                deleteImageView.tintColor = .darkGray
            case .delete:
                deleteImageView.alpha = 0.8
                let image = #imageLiteral(resourceName: "circle-x").withRenderingMode(.alwaysTemplate)
                deleteImageView.image = image
                deleteImageView.tintColor = UIColor(red:1.00, green:0.41, blue:0.41, alpha:1.0)
            }
        }
    }
    
    private var viewModel: PlaylistCellViewModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            titleLabel.text = viewModel.playlistName
            albumArtView.image = viewModel.podcastImage
        }
    }
    
    var albumArtView: UIImageView = {
        var album = UIImageView()
        return album
    }()
    
    var separatorView: UIView = {
        let separatorView = UIView()
        separatorView.backgroundColor = .clear
        return separatorView
    }()
    
    var titleLabel: UILabel = {
        let title = UILabel()
        title.textColor = .black
        title.font = Style.Font.PlaylistCell.title
        title.textAlignment = .left
        title.numberOfLines = 0
        return title
    }()
    
    var deleteImageView: UIImageView = {
        let delete = UIImageView()
        return delete
    }()
    
    var numberOfItemsLabel: UILabel = {
        let numberOfItems = UILabel()
        numberOfItems.textColor = .black
        numberOfItems.font = Style.Font.PlaylistCell.items
        numberOfItems.textAlignment = .left
        numberOfItems.numberOfLines = 0
        return numberOfItems
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setup(titleLabel: titleLabel)
        setup(numberOfItemsLabel: numberOfItemsLabel)
        setup(albumArtView: albumArtView)
        setup(deleteImageView: deleteImageView)
        selectionStyle = .none
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        albumArtView.layer.setCellShadow(contentView: self)
        setupSeparator()
    }
    
    private func setShadow() {
        layer.setCellShadow(contentView: contentView)
        let path =  UIBezierPath(roundedRect: bounds, cornerRadius: contentView.layer.cornerRadius)
        layer.shadowPath = path.cgPath
    }
    
    func configure(image: UIImage, title: String, subtitle: String?, mode: PlaylistCellMode) {
        setShadow()
        self.mode = mode
        self.albumArtView.image = image
        self.titleLabel.text = title
        if let subtitle = subtitle {
            self.numberOfItemsLabel.text = subtitle
        } else {
            self.numberOfItemsLabel.text = "Podcasts"
        }
    }
    
    func setupShadow() {
        DispatchQueue.main.async {
            let shadowOffset = CGSize(width:-0.45, height: 0.2)
            let shadowRadius: CGFloat = 1.0
            let shadowOpacity: Float = 0.4
            self.contentView.layer.shadowRadius = shadowRadius
            self.contentView.layer.shadowOffset = shadowOffset
            self.contentView.layer.shadowOpacity = shadowOpacity
        }
    }
    
    func setup(titleLabel: UILabel) {
        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 11, *) {
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 10).isActive = true
        } else {
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: contentView.bounds.width * 0.13).isActive = true
        }
        titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: contentView.bounds.height * -0.1).isActive = true
        titleLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.25).isActive = true
        titleLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.3).isActive = true
    }
    
    func setup(numberOfItemsLabel: UILabel) {
        contentView.addSubview(numberOfItemsLabel)
        numberOfItemsLabel.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 11, *) {
            numberOfItemsLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 10).isActive = true
        } else {
            numberOfItemsLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: contentView.bounds.width * 0.13).isActive = true
        }
        numberOfItemsLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: contentView.bounds.height * 0.02).isActive = true
        numberOfItemsLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.25).isActive = true
        numberOfItemsLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.3).isActive = true
    }
    
    private func setup(albumArtView: UIImageView) {
        contentView.addSubview(albumArtView)
        albumArtView.translatesAutoresizingMaskIntoConstraints = false
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 480, 960:
                albumArtView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: contentView.bounds.width * 0.04).isActive = true
                albumArtView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
                albumArtView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.7).isActive = true
                albumArtView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.28).isActive = true
            case 1136, 1334:
                albumArtView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 15).isActive = true
                albumArtView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
                albumArtView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.7).isActive = true
                albumArtView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.2).isActive = true
            case 2208:
                albumArtView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 15).isActive = true
                albumArtView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
                albumArtView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.7).isActive = true
                albumArtView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.2).isActive = true
            default:
                deleteImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.46).isActive = true
            }
        }
    }
    
    func setup(deleteImageView: UIImageView) {
        contentView.addSubview(deleteImageView)
        deleteImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addConstraint(NSLayoutConstraint(item: deleteImageView,
                                                     attribute: .centerY,
                                                     relatedBy: .equal,
                                                     toItem: contentView,
                                                     attribute: .centerY,
                                                     multiplier: 1.0,
                                                     constant: 0.0))
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 480, 960:
                deleteImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.08).isActive = true
                deleteImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.26).isActive = true
                deleteImageView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: contentView.bounds.width * -0.04).isActive = true
            case 1136, 1334:
                deleteImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.08).isActive = true
                deleteImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.26).isActive = true
                deleteImageView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -18.75).isActive = true
            case 2208:
                deleteImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.1).isActive = true
                deleteImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.45).isActive = true
                deleteImageView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: contentView.bounds.width * -0.04).isActive = true
            default:
                deleteImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.08).isActive = true
                deleteImageView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: contentView.bounds.width * -0.04).isActive = true
                deleteImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.46).isActive = true
            }
        }
    }
    
    func setupSeparator() {
        setup(separatorView: separatorView)
        DispatchQueue.main.async {
            self.albumArtView.layer.cornerRadius = 4
            self.albumArtView.layer.borderWidth = 0.5
            let containerLayer = CALayer()
            containerLayer.shadowColor = UIColor.darkText.cgColor
            containerLayer.shadowRadius = 2
            containerLayer.shadowOffset = CGSize(width: 1, height: 1)
            containerLayer.shadowOpacity = 0.6
            self.albumArtView.layer.masksToBounds = true
            containerLayer.addSublayer(self.albumArtView.layer)
            self.layer.addSublayer(containerLayer)
        }
    }
    
    func setup(separatorView: UIView) {
        contentView.addSubview(separatorView)
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            separatorView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.01),
            separatorView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            separatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
            ])
    }
    
    func configure(with title: String, detail: String, image: UIImage) {
        setShadow()
        self.albumArtView.image = image
        self.titleLabel.text = title
        self.numberOfItemsLabel.text = detail
    }
    
    func configureWith(model: PlaylistCellViewModel) {
        self.viewModel = model
    }
}

protocol PlaylistsViewControllerOutput {
    
}


protocol PlaylistsViewControllerInput {
    func didAssignToPlaylist(episode: Episode)
}


import UIKit

/// A custom table view controller to allow users to select `VirtualObject`s for placement in the scene.
class SelectionViewController: UITableViewController, UIAdaptivePresentationControllerDelegate {
    
    var items = [String]()
    
    @objc open static func instantiate() -> SelectionViewController {
        let tableVC = SelectionViewController()
        let popOverViewController: SelectionViewController = tableVC
        popOverViewController.modalPresentationStyle = UIModalPresentationStyle.popover
        popOverViewController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.up
        popOverViewController.popoverPresentationController?.backgroundColor = UIColor.white
        return popOverViewController
    }
    
    @objc open var completionHandler: ((_ selectRow: Int) -> Void)?
    
    fileprivate var selectRow:Int?
    
    var selectedObjectRows = IndexSet()
    
    weak var delegate: SelectionViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(ObjectCell.self, forCellReuseIdentifier: ObjectCell.reuseIdentifier)
        tableView.register(CancelCell.self, forCellReuseIdentifier: CancelCell.reuseIdentifier)
        tableView.separatorEffect = UIVibrancyEffect(blurEffect: UIBlurEffect(style: .light))
        tableView.rowHeight = 70
    }
    
    override func viewWillLayoutSubviews() {
        preferredContentSize = CGSize(width: 350, height: tableView.contentSize.height)
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        if (selectRow != nil) {
            let selectIndexPath:IndexPath = IndexPath(row: selectRow!, section: 0)
            tableView.scrollToRow(at: selectIndexPath, at: .middle, animated: true)
        }
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let object = items[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        if selectedObjectRows.contains(indexPath.row) {
            delegate?.virtualObjectSelectionViewController(self, didDeselectObject: object)
        } else {
            delegate?.virtualObjectSelectionViewController(self, didSelectObject: object)
        }
        self.dismiss(animated: true, completion: {
            UIView.animate(withDuration: 0.2) {
                self.tableView.alpha = 0
            }
            if self.completionHandler != nil {
                let selectRow:Int = indexPath.row
                self.completionHandler!(selectRow)
            }
        })
    }
    
    // MARK: - UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == items.count - 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CancelCell.reuseIdentifier, for: indexPath) as? CancelCell else {
                fatalError("Expected `\(CancelCell.self)` type for reuseIdentifier \(CancelCell.reuseIdentifier). Check the configuration in Main.storyboard.")
            }
            cell.modelName = items[indexPath.row]
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ObjectCell.reuseIdentifier, for: indexPath) as? ObjectCell else {
                fatalError("Expected `\(ObjectCell.self)` type for reuseIdentifier \(ObjectCell.reuseIdentifier). Check the configuration in Main.storyboard.")
            }
            cell.modelName = items[indexPath.row]
            if selectedObjectRows.contains(indexPath.row) {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
            return cell
        }
    }
    
//    @objc open func setItems(_ items:Array<String>) {
//        self.items = items
//    }
    
    @objc open func setSelectRow(_ selectRow:Int) {
        self.selectRow = selectRow
    }
    
    override func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
    }
    
    override func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.backgroundColor = .clear
    }
}

//extension PlaylistsViewController: PlaylistsViewControllerInput {
//    func didAssignToPlaylist(episode: Episode) {
//
//    }
//}


//import UIKit
//import CoreData
//
//final class PlaylistsViewController: BaseTableViewController {
//    
//    weak var podcastDelegate: PodcastDelegate?
//    weak var delegate: PlaylistsViewControllerDelegate?
//    
//    var coordinator: PlaylistsCoordinator?
//    
//    var reference: PlaylistsReference = .checkList
//    var tap: UIGestureRecognizer!
//    private var entryPop: EntryPopover = EntryPopover()
//    var mode: PlaylistsInteractionMode = .add
//    var casterItemToSave: PodcastItem!
//    var index: Int!
//    var item: PodcastItem!
//    
//    var managedContext: NSManagedObjectContext! {
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
//        let context = appDelegate.persistentContainer.viewContext
//        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
//        return context
//    }
//    
////    lazy var fetchedResultsController:NSFetchedResultsController<PodcastPlaylist> = {
////        let fetchRequest:NSFetchRequest<PodcastPlaylist> = PodcastPlaylist.fetchRequest()
////        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "playlistId", ascending: true)]
////        var controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedContext, sectionNameKeyPath: nil, cacheName: nil)
////        do {
////            try? controller.performFetch()
////        }
////        return controller
////    }()
////
//    var background = UIView()
//    
//   // var playlistsDataSource: TableViewDataSource<PlaylistsViewController>!
//    let persistentContainer = NSPersistentContainer(name: "Podcatch")
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        tableView.register(PlaylistCell.self)
//        initialize()
//        edgesForExtendedLayout = []
//    }
//    
//    func initialize() {
//     //  entryPop.delegate = self
//      //  playlistsDataSource = TableViewDataSource(tableView: tableView, identifier: PlaylistCell.reuseIdentifier, fetchedResultsController: fetchedResultsController, delegate: self)
//        leftButtonItem  = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(edit))
//        rightButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "plus-red").withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(addPlaylist))
//        background.frame = UIScreen.main.bounds
//        view.addSubview(background)
//        view.sendSubview(toBack: background)
//        tableView.backgroundColor = .white
//        tableView.register(PlaylistCell.self, forCellReuseIdentifier: PlaylistCell.reuseIdentifier)
//        tableView.delegate = self
//        rightButtonItem.tintColor = .white
//        navigationItem.setRightBarButton(rightButtonItem, animated: false)
//        navigationItem.setLeftBarButton(leftButtonItem, animated: false)
////        playlistsDataSource.reloadData()
////        tableView.dataSource = playlistsDataSource
////        playlistsDataSource.setIcon(icon: #imageLiteral(resourceName: "podcast-icon").withRenderingMode(.alwaysTemplate))
////        playlistsDataSource.setText(text: "Create playlists with your favorite podcasts!")
////        if playlistsDataSource.itemCount == 0 {
////            navigationItem.leftBarButtonItem = nil
////        }
//        //        coordinator?.viewDidLoad(self)
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        setupNavbar()
//    }
//    
//    func addPlaylist() {
//        
//    }
//    
//    private func setupNavbar() {
//        DispatchQueue.main.async {
//            let backImage = #imageLiteral(resourceName: "back").withRenderingMode(.alwaysTemplate)
//            self.navigationController?.navigationBar.backIndicatorImage = backImage
//            self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = backImage
//        }
//    }
//    
//    override func viewDidDisappear(_ animated: Bool) {
//        super.viewDidDisappear(animated)
//        mode = .add
//    }
//    
//    @objc func edit() {
//        mode = mode == .edit ? .add : .edit
//        if navigationItem.leftBarButtonItem != nil {
//            leftButtonItem.title = mode == .edit ? "Done" : "Edit"
//        }
//        DispatchQueue.main.async {
//            self.tableView.reloadData()
//        }
//    }
//}
//
//extension PlaylistsViewController: UITableViewDelegate {
//    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UIScreen.main.bounds.height / 7.5
//    }
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        switch mode {
//        case .edit:
//            editMode(indexPath: indexPath)
//        case .add:
//            addFor(indexPath: indexPath)
//        }
//    }
//    
//    func addFor(indexPath: IndexPath) {
//      //  guard let text = fetchedResultsController.object(at: indexPath).playlistId else { return }
////        switch reference {
////        case .addPodcast:
////
////            let cell = tableView.dequeueReusableCell(withIdentifier: PlaylistCell.reuseIdentifier, for: indexPath) as! PlaylistCell
////            let podcastItem = PodcastPlaylistItem(context: fetchedResultsController.managedObjectContext)
////
////            podcastItem.audioUrl = item.episodes[index].audioUrlSting
////            podcastItem.artistFeedUrl = item.feedUrl
////
////            let isoDate = item.episodes[index].date
////
////            let dateFormatter = DateFormatter()
////            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
////            if let date = dateFormatter.date(from:isoDate) {
////                let calendar = Calendar.current
////                let components = calendar.dateComponents([.year, .month, .day, .hour], from: date)
////                let finalDate = calendar.date(from:components)! as NSDate
////                podcastItem.date = finalDate
////            }
////
////            podcastItem.artistId = item.artistId
////            podcastItem.playlistId = cell.titleLabel.text!
////            podcastItem.duration = item.episodes[index].duration
////            podcastItem.artistName = item.podcastArtist
////            podcastItem.stringDate = item.episodes[index].date
////            podcastItem.artworkUrl = item.podcastArtUrlString
////            podcastItem.episodeTitle = item.episodes[index].title
////            podcastItem.episodeDescription = item.episodes[index].description
////            podcastItem.tags = item.nsTags()
////
////            if let urlString = item.podcastArtUrlString, let url = URL(string: urlString) {
////                UIImage.downloadImage(url: url) { image in
////                    let podcastArtImageData = UIImageJPEGRepresentation(image, 1)
////                    if let podcastArtImageData = podcastArtImageData {
////                        podcastItem.artwork = NSData.init(data: podcastArtImageData)
////                    }
////                }
////            }
////
////            let playlist = fetchedResultsController.object(at: indexPath)
////            podcastItem.playlist = playlist
////            playlist.addToPodcast(podcastItem)
////
////            if let context = podcastItem.managedObjectContext {
////
////                context.performAndWait() {
////                    do {
////                        try context.save()
////                    } catch let error {
////                        print(error.localizedDescription)
////                    }
////                }
////            }
////
////        case .checkList:
////            guard text != "" else { return }
////            addNewPlaylist(text: text, from: indexPath)
////        }
////        reference = .checkList
//    }
//    
//    
//    func add(text: String) {
////        reference = .checkList
////        DispatchQueue.main.async { self.playlistsDataSource.reloadData() }
////        delegate?.didAssignPlaylist(with: text)
//    }
//    
//    func addToPlaylist(with name: String) {
////        guard name != "" else { return  }
////        reference = .checkList
////        DispatchQueue.main.async {
////            self.playlistsDataSource.reloadData()
////        }
//    }
//    
//    func addNewPlaylist(text: String, from indexPath: IndexPath) {
////        let casts = fetchedResultsController.object(at: indexPath)
////        let playlist = PlaylistViewController(index: 0, player: AudioFilePlayer(), playlist: casts)
////        playlist.playlistId = text
////        delegate?.playlistSelected(for: casts)
//    }
//    
//    func editMode(indexPath: IndexPath) {
////        guard let title = fetchedResultsController.object(at: indexPath).playlistName else { return }
////        DispatchQueue.main.async {
////            let actionSheetController: UIAlertController = UIAlertController(title: "Are you sure?", message: "Pressing okay will delete \(title).", preferredStyle: .alert)
////            let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action in
////                actionSheetController.dismiss(animated: false, completion: nil)
////            }
////            let okayAction: UIAlertAction =  UIAlertAction(title: "Okay", style: .destructive) { action in
////                self.removeFor(indexPath: indexPath)
////            }
////            actionSheetController.addAction(cancelAction)
////            actionSheetController.addAction(okayAction)
////            self.present(actionSheetController, animated: true, completion: nil)
////        }
//    }
//    
//    func removeFor(indexPath: IndexPath) {
////        
////        let item = fetchedResultsController.object(at: indexPath)
////        
////        guard let podcast = item.podcast else { return }
////        
////        for (_, podcast) in (podcast.enumerated()) {
////            if let pod = podcast as? PodcastPlaylistItem, let audioUrl = pod.audioUrl {
////                LocalStorageManager.deleteSavedItem(itemUrlString: audioUrl)
////            }
////        }
////        
////        managedContext.delete(item)
////        
////        do {
////            try managedContext.save()
////            playlistsDataSource.reloadData()
////        } catch let error {
////            print(error.localizedDescription)
////        }
////        
////        if let count = fetchedResultsController.fetchedObjects?.count {
////            if count == 0 {
////                self.mode = .add
////                self.leftButtonItem.title = "Edit"
////            }
////            if self.playlistsDataSource.itemCount == 0 {
////                DispatchQueue.main.async {
////                    self.navigationItem.leftBarButtonItem = nil
////                }
////            }
////        }
//    }
//}
//
////extension PlaylistsViewController: EntryPopoverDelegate {
////
////    func userDidEnterPlaylistName(name: String) {
////        guard name != "" else { return }
////        var playlistDataStack = PlaylistsCoreData()
////        playlistDataStack.save(name: name, uid: "none")
////        playlistsDataSource.reloadData()
////        if playlistsDataSource.itemCount > 0 {
////            navigationItem.leftBarButtonItem = leftButtonItem
////        }
////        tableView.reloadData()
////        playlistsDataSource.reloadData()
////    }
////
////    @objc func addPlaylist() {
////        UIView.animate(withDuration: 0.05) {
////            self.entryPop.showPopView(viewController: self)
////            self.entryPop.popView.isHidden = false
////        }
////        tap = UITapGestureRecognizer(target: self, action: #selector(hidePop))
////        view.addGestureRecognizer(tap)
////        entryPop.popView.doneButton.addTarget(self, action: #selector(hidePop), for: .touchUpInside)
////    }
////
////    @objc func hidePop() {
////        entryPop.hidePopView(viewController: self)
////        view.removeGestureRecognizer(tap)
////        view.endEditing(true)
////    }
////}
//
////extension PlaylistsViewController: TableViewDataSourceDelegate {
////
////    typealias Cell = PlaylistCell
////    typealias Object = PodcastPlaylist
////
////    func configure(_ cell: PlaylistCell, for object: PodcastPlaylist) {
////
////        var cellMode: PlaylistCellMode = .select
////
////        cellMode = mode == .add ? .select : .delete
////
////        if let podcast = object.podcast as? Set<PodcastPlaylistItem>, podcast.count > 0 {
////
////            for (index, pod) in podcast.enumerated() {
////                if index == 0 {
////                    if let data = pod.artwork, let artworkImage = UIImage(data: Data.init(referencing: data)), let title = object.playlistName {
////                        cell.configure(image: artworkImage, title: title, subtitle: "Episodes: \(podcast.count)", mode: cellMode)
////                    }
////                }
////            }
////
////        } else {
////
////            if let name = object.playlistName, let count = object.podcast?.count {
////                cell.configure(image: #imageLiteral(resourceName: "light-placehoder-2"), title: name, subtitle: "Episodes: \(count)", mode: cellMode)
////            } else {
////                cell.configure(image: #imageLiteral(resourceName: "light-placehoder-2"), title: "temp", subtitle: "Episodes: Unknown", mode: cellMode)
////            }
////        }
////    }
////}
//
