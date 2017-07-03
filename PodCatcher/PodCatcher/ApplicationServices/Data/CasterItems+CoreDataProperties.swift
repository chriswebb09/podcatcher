//
//  CasterItems+CoreDataProperties.swift
//  
//
//  Created by Christopher Webb-Orenstein on 7/2/17.
//
//

import Foundation
import CoreData


extension CasterItems {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CasterItems> {
        return NSFetchRequest<CasterItems>(entityName: "CasterItems")
    }

    @NSManaged public var audioUrl: String?
    @NSManaged public var collectionName: String?
    @NSManaged public var creatorName: String?
    @NSManaged public var episodeID: String?
    @NSManaged public var playCount: Int16
    @NSManaged public var playTime: Double
    @NSManaged public var title: String?
    @NSManaged public var audioFile: NSData?
    @NSManaged public var podcaster: PodCaster?

}
