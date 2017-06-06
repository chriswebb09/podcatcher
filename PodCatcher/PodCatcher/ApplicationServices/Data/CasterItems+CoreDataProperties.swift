//
//  CasterItems+CoreDataProperties.swift
//  PodCatcher
//
//  Created by Christopher Webb-Orenstein on 6/6/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
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
    @NSManaged public var playCount: Int16
    @NSManaged public var playTime: Double
    @NSManaged public var title: String?
    @NSManaged public var podcaster: PodCaster?

}
