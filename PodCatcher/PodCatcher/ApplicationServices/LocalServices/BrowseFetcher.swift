//
//  BrowseFetcher.swift
//  PodCatcher
//
//  Created by Christopher Webb on 5/12/18.
//  Copyright © 2018 Christopher Webb-Orenstein. All rights reserved.
//

import Foundation
import CoreData
import UIKit

import Foundation

protocol BrowseFetcher: class {
    var globalDefault: DispatchQueue { get }
    var interactor: SearchResultsIteractor { get set }
    func fetchBrowse(completion: @escaping ([Podcast]?, Error?) -> Void)
}

extension BrowseFetcher {
    
    func fetchBrowse(completion: @escaping ([Podcast]?, Error?) -> Void) {
        
        let results = [Podcast]()
        
        var setResults = Set<Podcast>()
        
        let browsePodcastGroup = DispatchGroup()
        
        var ids: [String] = ["290783428", "1074507850", "941907967", "173001861", "121493675", "1315040130", "1335814741", "1091709555", "121493675"]
        
        for i in 0..<ids.count {
            
            self.globalDefault.async(group: browsePodcastGroup) { [weak self] in
                
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
                            DispatchQueue.main.async {
                                if !results.contains(caster) {
                                    setResults.insert(caster)
                                }
                            }
                        }
                        if setResults.count >= 4 {
                            let resultsMap = setResults.map { $0 }
                            DispatchQueue.main.async {
                                completion(resultsMap, nil)
                                return
                            }
                        }
                    }
                    
                }
            }
        }
        print("Waiting for completion...")
        browsePodcastGroup.notify(queue: self.globalDefault) {
            print("Notify received, done waiting.")
        }
        browsePodcastGroup.wait()
        print("Done waiting.")
    }
}
