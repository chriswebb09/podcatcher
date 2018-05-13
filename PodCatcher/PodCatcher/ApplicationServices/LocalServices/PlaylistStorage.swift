//
//  PlaylistStorage.swift
//  PodCatcher
//
//  Created by Christopher Webb on 5/12/18.
//  Copyright © 2018 Christopher Webb-Orenstein. All rights reserved.
//

import Foundation
import CoreData
import UIKit

protocol PlaylistStorage: class {
    var playlists: [NSManagedObject] { get set }
    var interactor: SearchResultsIteractor { get set }
    var searchResultsDataStore: SearchResultsDataStore { get set }
}
