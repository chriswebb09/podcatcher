//
//  PlaylistDatabase.swift
//  PodCatcher
//
//  Created by Christopher Webb on 5/12/18.
//  Copyright © 2018 Christopher Webb-Orenstein. All rights reserved.
//

import Foundation
import CoreData
import UIKit


class PlaylistDatabase: PlaylistReader, PlaylistWriter {
    
    var persistentContainer: NSPersistentContainer!
    
    lazy var backgroundContext: NSManagedObjectContext = {
        return self.persistentContainer.newBackgroundContext()
    }()
    
    var playlists: [NSManagedObject] = []
    
    var interactor: SearchResultsIteractor = SearchResultsIteractor()
    
    var searchResultsDataStore: SearchResultsDataStore = SearchResultsDataStore()
    
    init(container: NSPersistentContainer) {
        self.persistentContainer = container
        self.persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    convenience init() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Can not get shared app delegate")
        }
        self.init(container: appDelegate.persistentContainer)
    }
    
    
    func fetchPlaylists() -> [Playlist] {
        let request: NSFetchRequest<Playlist> = Playlist.fetchRequest()
        let results = try? persistentContainer.viewContext.fetch(request)
        return results ?? [Playlist]()
    }
    
    func remove(objectID: NSManagedObjectID ) {
        let obj = backgroundContext.object(with: objectID)
        backgroundContext.delete(obj)
    }
    
    func save() {
        if backgroundContext.hasChanges {
            do {
                try backgroundContext.save()
            } catch {
                print("Save error \(error)")
            }
        }
    }
}
