//
//  PlaylistReader.swift
//  PodCatcher
//
//  Created by Christopher Webb on 5/12/18.
//  Copyright © 2018 Christopher Webb-Orenstein. All rights reserved.
//

import Foundation
import CoreData
import UIKit

protocol PlaylistReader: PlaylistStorage {
    func fetchPlaylists(managedContext: NSManagedObjectContext) -> [Playlist]
}

extension PlaylistReader {
    func fetchPlaylists(managedContext: NSManagedObjectContext) -> [Playlist] {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName:"Playlist")
        do {
            let playlist = try managedContext.fetch(fetchRequest) as! [Playlist]
            return playlist
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return []
        }
    }
}
