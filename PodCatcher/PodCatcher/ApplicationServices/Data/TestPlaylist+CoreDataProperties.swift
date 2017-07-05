//
//  TestPlaylist+CoreDataProperties.swift
//  
//
//  Created by Christopher Webb-Orenstein on 7/5/17.
//
//

import Foundation
import CoreData


extension TestPlaylist {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TestPlaylist> {
        return NSFetchRequest<TestPlaylist>(entityName: "TestPlaylist")
    }

    @NSManaged public var title: String?
    @NSManaged public var testPlaylist: NSSet?

}

// MARK: Generated accessors for testPlaylist
extension TestPlaylist {

    @objc(addTestPlaylistObject:)
    @NSManaged public func addToTestPlaylist(_ value: TestPlaylists)

    @objc(removeTestPlaylistObject:)
    @NSManaged public func removeFromTestPlaylist(_ value: TestPlaylists)

    @objc(addTestPlaylist:)
    @NSManaged public func addToTestPlaylist(_ values: NSSet)

    @objc(removeTestPlaylist:)
    @NSManaged public func removeFromTestPlaylist(_ values: NSSet)

}
