//
//  FeaturedFetcher.swift
//  PodCatcher
//
//  Created by Christopher Webb on 5/12/18.
//  Copyright © 2018 Christopher Webb-Orenstein. All rights reserved.
//

import Foundation
import CoreData
import UIKit

protocol FeaturedFetcher: class {
    var globalDefault: DispatchQueue { get }
    var globalDefault2: DispatchQueue { get }
    var interactor: SearchResultsIteractor { get set }
    
    func getFeaturedPodcasts(completion: @escaping ([Podcast]?, Error?) -> Void)
    func searchForData(from id: String, completion: @escaping ([JSON?]?, Error?) -> Void)
    func featureFetch(completion: @escaping ([Podcast]?, Error?) -> Void)
}

extension FeaturedFetcher {
    
    func getFeaturedPodcasts(completion: @escaping ([Podcast]?, Error?) -> Void) {
        
        let topPodcastGroup = DispatchGroup()
        
        let ids: [String] = ["1346207297", "809264944", "1344894187", "1279361017", "121493675", "1091709555", "121493675"]
        
        for (_, id) in ids.enumerated() {
            print("featured ids")
            self.globalDefault.async(group: topPodcastGroup) { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.searchForData(from: id) { json, error in
                    if error != nil {
                        print(error?.localizedDescription ?? "No specific error")
                    } else {
                        strongSelf.getModels(from: json) { podcasts in
                            if error != nil {
                                completion(nil, error)
                            } else {
                                DispatchQueue.main.async {
                                    completion(podcasts, nil)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func searchForData(from id: String, completion: @escaping ([JSON?]?, Error?) -> Void) {
        interactor.setLookup(term: id)
        interactor.searchForTracksFromLookup { result, arg  in
            if let error = arg {
                completion(nil, error)
            }
            DispatchQueue.main.async {
                completion(result, nil)
            }
        }
    }
    
    func getModels(from data: [JSON?]?, completion: @escaping ([Podcast]?) -> Void) {
        var results = [Podcast]()
        var setResults = Set<Podcast>()
        guard let resultItem = data else { return }
        resultItem.forEach { resultingData in
            guard let resultingData = resultingData else { return }
            if let caster = Podcast(json: resultingData) {
                DispatchQueue.main.async {
                    if !results.contains(caster) {
                        setResults.insert(caster)
                    }
                }
            }
            results = setResults.map { $0 }
            DispatchQueue.main.async {
                completion(results)
            }
        }
    }
    
    func featureFetch(completion: @escaping ([Podcast]?, Error?) -> Void) {
        let results = [Podcast]()
        var setResults = Set<Podcast>()
        let topPodcastGroup = DispatchGroup()
        
        var ids: [String] = ["1346207297", "809264944", "1344894187","978052928", "394775318", "1279361017", "121493675", "1091709555", "121493675"]
        
        for i in 0..<ids.count {
            print("featured ids")
            
            self.globalDefault2.async(group: topPodcastGroup) { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.interactor.setLookup(term: ids[i])
                strongSelf.interactor.searchForTracksFromLookup { result, arg  in
                    if let error = arg {
                        completion(nil, error)
                    }
                    
                    guard let resultItem = result else { return }
                    resultItem.forEach { resultingData in
                        guard let resultingData = resultingData else { return }
                        if let caster = Podcast(json: resultingData) {
                            caster.updateEpisodesOnBackground()
                            DispatchQueue.main.async {
                                if !results.contains(caster) {
                                    setResults.insert(caster)
                                }
                            }
                        }
                    }
                    if setResults.count >= 1 {
                        let resultsMap = setResults.map { $0 }
                        DispatchQueue.main.async {
                            completion(resultsMap, nil)
                        }
                    }
                }
            }
        }
        print("Waiting for featured completion...")
        topPodcastGroup.notify(queue: self.globalDefault2) {
            print("Notify received for features , done waiting.")
        }
        topPodcastGroup.wait()
        print("Done waiting.")
    }
}
