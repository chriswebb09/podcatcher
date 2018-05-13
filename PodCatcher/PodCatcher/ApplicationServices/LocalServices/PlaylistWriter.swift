//
//  PlaylistWriter.swift
//  PodCatcher
//
//  Created by Christopher Webb on 5/12/18.
//  Copyright © 2018 Christopher Webb-Orenstein. All rights reserved.
//

import Foundation
import CoreData
import UIKit

protocol PlaylistWriter: PlaylistStorage {
    
    var persistentContainer: NSPersistentContainer! { get set }
    var backgroundContext: NSManagedObjectContext { get }
    func insertPlaylist(title: String) -> Playlist?
    func savePlaylist(manageContext: NSManagedObjectContext, title: String)
}

extension PlaylistWriter {
    
    func savePlaylist(manageContext: NSManagedObjectContext, title: String) {
        let entity = NSEntityDescription.entity(forEntityName: "Playlist", in: manageContext)!
        let playlist = NSManagedObject(entity: entity, insertInto: manageContext)
        playlist.setValue(title, forKey: "name")
        let uuid = UUID().uuidString
        let date = Date()
        playlist.setValue(uuid, forKey: "playlistId")
        playlist.setValue(date, forKey: "dateCreated")
        do {
            try manageContext.save()
            playlists.append(playlist)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func insertPlaylist(title: String) -> Playlist? {
        guard let playlist = NSEntityDescription.insertNewObject(forEntityName: "Playlist", into: backgroundContext) as? Playlist else { return nil }
        playlist.name = title
        playlist.dateCreated = NSDate()
        playlist.playlistId = UUID().uuidString
        playlist.numberOfItems = 0
        playlist.timeListened = 0
        return playlist
    }
}
