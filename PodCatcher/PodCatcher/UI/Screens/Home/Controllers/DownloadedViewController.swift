//
//  DownloadedViewController.swift
//  PodCatcher
//
//  Created by Christopher Webb-Orenstein on 1/15/18.
//  Copyright © 2018 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit
import CoreData

//class DownloadedViewController: BaseTableViewController {
//    
//    var managedContext: NSManagedObjectContext! {
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
//        let context = appDelegate.persistentContainer.viewContext
//        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
//        return context
//    }
//    
//    lazy var fetchedResultsController:NSFetchedResultsController<Podcast> = {
//        let fetchRequest:NSFetchRequest<Podcast> = Podcast.fetchRequest()
//        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "episodeTitle", ascending: true)]
//        var controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedContext, sectionNameKeyPath: nil, cacheName: nil)
//        do {
//            try? controller.performFetch()
//        }
//        return controller
//    }()
//    
//    var background = UIView()
//    
//    var playlistsDataSource: TableViewDataSource<DownloadedViewController>!
//    let persistentContainer = NSPersistentContainer(name: "PodCatcher")
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        initialize()
//        edgesForExtendedLayout = []
//        tableView.register(DownloadedCell.self)
//        tableView.dataSource = playlistsDataSource
//        tableView.delegate = self
//    }
//    
//    func initialize() {
//        playlistsDataSource = TableViewDataSource(tableView: tableView, identifier: "DownloadedCell", fetchedResultsController: fetchedResultsController, delegate: self)
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        self.tableView.translatesAutoresizingMaskIntoConstraints = false
//        self.tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 2).isActive = true
//        self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
//        self.tableView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1).isActive = true
//        self.tableView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
//    }
//    
//}
//
//extension DownloadedViewController: TableViewDataSourceDelegate {
//    func configure(_ cell: DownloadedCell, for object: Podcast) {
//        if let _ = object.episodeTitle, let artdata = object.podcastImage, let title = object.episodeTitle {
//            DispatchQueue.main.async {
//                if let image = UIImage(data: artdata as Data) {
//                    cell.configureCell(with: image, title: title)
//                } else {
//                    cell.configureCell(with: nil, title: title)
//                }
//            }
//        }
//    }
//    
//    typealias Object = Podcast
//    
//    typealias Cell = DownloadedCell
//}
//
//extension DownloadedViewController: UITableViewDelegate {
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print(indexPath)
//    }
//    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UIScreen.main.bounds.height / 10
//    }
//}
