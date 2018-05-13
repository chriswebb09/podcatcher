//
//  DataStore.swift
//  PodCatcher
//
//  Created by Christopher Webb on 5/12/18.
//  Copyright © 2018 Christopher Webb-Orenstein. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class DataStore: BrowseFetcher, FeaturedFetcher {
    
    let notificationCenter: NotificationCenter
    
    private let queue = DispatchQueue(label: "")
    
    init(notificationCenter: NotificationCenter) {
        self.notificationCenter = notificationCenter
    }
    
    var subscriptionDatabase = SubscriptionDatabase()
    var playlistDatabase = PlaylistDatabase()
    
    let globalDefault = DispatchQueue.global()
    let globalDefault2 = DispatchQueue.global()
    
    
    var playlists: [NSManagedObject] = []
    
    var interactor = SearchResultsIteractor()
    
    var searchResultsDataStore = SearchResultsDataStore()
    
    private var podcasts: [Podcast] = [] {
        didSet {
            self.notificationCenter.post(name: .dataStorePodcastsChanged, object: self, userInfo: nil)
        }
    }
    
    private var featuredPodcasts: [Podcast] = [] {
        didSet {
            self.notificationCenter.post(name: .dataStorePodcastsChanged, object: self, userInfo: nil)
        }
    }
    
    private var episodes: [Episodes] = [] {
        didSet {
            self.notificationCenter.post(name: .dataStoreEpisodesChanged, object: self, userInfo: nil)
        }
    }
    
    func getPodcasts(completion: @escaping ([Podcast]) -> Void) {
        DispatchQueue.main.async {
            completion(self.podcasts)
        }
    }
    
    func getFeatured(completion: @escaping ([Podcast]) -> Void) {
        
        DispatchQueue.main.async { [weak self] in
            if let strongSelf = self {
                completion(strongSelf.featuredPodcasts)
            }
        }
        
    }
    
    func setFeatured() {
        featureFetch { [weak self] podcasts, error in
            if let strongSelf = self {
                DispatchQueue.main.async {
                    strongSelf.featuredPodcasts = podcasts!
                }
            }
        }
    }
    
    func getEpisodes(_ predicate: @escaping (Episodes) -> Bool, completion: @escaping ([Episodes]) -> Void) {
        
        DispatchQueue.main.async { [weak self] in
            if let strongSelf = self {
                completion(strongSelf.episodes.filter(predicate))
            }
        }
    }
    
    func set(podcasts: [Podcast], episodes: [Episodes]) {
        self.queue.async {
            self.podcasts = podcasts
            self.episodes = episodes
        }
    }
    
    func block(_ capture: @escaping (inout [Podcast], inout [Episodes]) -> Void) {
        self.queue.async {
            capture(&self.podcasts, &self.episodes)
        }
    }
    
    func fetchSubscribed(managedContext: NSManagedObjectContext) -> [SubsciptionCellViewModel] {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName:"Podcaster")
        var models = [SubsciptionCellViewModel]()
        do {
            let podcasts = try managedContext.fetch(fetchRequest) as! [Podcaster]
            dump(podcasts)
            for podcast in podcasts {
                
                if let data = podcast.podcastArtworkImage {
                    let image = UIImage(data: data as Data)
                    let model = SubsciptionCellViewModel(trackName: podcast.podcastTitle!, albumImageURL: image!)
                    models.append(model)
                }
                
            }
            return models
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return models
        }
    }
    
    func getTopItems(completion: @escaping ([TopItem]?, Error?) -> Void) {
        let concurrentQueue = DispatchQueue(label: "concurrent", qos: .background, attributes: .concurrent, autoreleaseFrequency: .inherit, target: nil)
        concurrentQueue.async { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.searchResultsDataStore.pullFeedTopPodcasts { data, error in
                if let error = error {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                }
                guard let data = data else { return }
                DispatchQueue.main.async {
                    completion(data, nil)
                }
            }
        }
    }
}
