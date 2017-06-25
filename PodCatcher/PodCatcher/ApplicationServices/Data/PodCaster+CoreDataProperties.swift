//
//  PodCaster+CoreDataProperties.swift
//  
//
//  Created by Christopher Webb-Orenstein on 6/25/17.
//
//

import Foundation
import CoreData


extension PodCaster {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PodCaster> {
        return NSFetchRequest<PodCaster>(entityName: "PodCaster")
    }

    @NSManaged public var name: String?
    @NSManaged public var totalPlayTime: Double
    @NSManaged public var image: NSData?
    @NSManaged public var podCasterItems: NSSet?

}

// MARK: Generated accessors for podCasterItems
extension PodCaster {

    @objc(addPodCasterItemsObject:)
    @NSManaged public func addToPodCasterItems(_ value: CasterItems)

    @objc(removePodCasterItemsObject:)
    @NSManaged public func removeFromPodCasterItems(_ value: CasterItems)

    @objc(addPodCasterItems:)
    @NSManaged public func addToPodCasterItems(_ values: NSSet)

    @objc(removePodCasterItems:)
    @NSManaged public func removeFromPodCasterItems(_ values: NSSet)

}
