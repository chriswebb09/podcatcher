//
//  SubscriptionStorage.swift
//  PodCatcher
//
//  Created by Christopher Webb on 5/12/18.
//  Copyright © 2018 Christopher Webb-Orenstein. All rights reserved.
//

import Foundation
import CoreData
import UIKit

protocol SubscriptionStorage: class {
    var podcasts: [NSManagedObject] { get set }
}
