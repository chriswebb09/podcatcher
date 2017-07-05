//
//  TestPlaylists+CoreDataProperties.swift
//  
//
//  Created by Christopher Webb-Orenstein on 7/5/17.
//
//

import Foundation
import CoreData


extension TestPlaylists {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TestPlaylists> {
        return NSFetchRequest<TestPlaylists>(entityName: "TestPlaylists")
    }

    @NSManaged public var userID: String?
    @NSManaged public var testPlaylists: TestPlaylist?

}
