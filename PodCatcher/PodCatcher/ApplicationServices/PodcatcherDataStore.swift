//
//  PodcatcherDataStore.swift
//  PodCatcher
//
//  Created by Christopher Webb-Orenstein on 6/14/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

class PodcatcherDataStore {
    let fetcher = PCMediaPlayer()
    
    func pullPodcastsFromUser(completion: @escaping ([Caster]) -> Void) {
        fetcher.getPlaylists { casts, lists in
            if let lists = lists {
                let listSet = Set(lists)
                DispatchQueue.main.async {
                    completion(Array(listSet))
                }
            }
        }
    }
    
}
