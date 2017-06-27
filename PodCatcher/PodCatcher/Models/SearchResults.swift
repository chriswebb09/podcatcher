//
//  SearchResult.swift
//  PodCatcher
//
//  Created by Christopher Webb-Orenstein on 6/25/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

enum ResultType {
    case podcast, topic, caster, term
}

struct Episodes {
    var title: String
    var date: String
    var description: String
    var duration: Double
}

protocol PodcastSearchResult {
    var podcastArtUrlString: String? { get set }
    var podcastTitle: String? { get set }
    var podcastArtist: String? { get set }
    var podcastSearchType: ResultType? { get set }
}

class TermSearchResult: PodcastSearchResult {
    var podcastSearchType: ResultType?
    var podcastArtist: String?
    var podcastTitle: String?
    var podcastArtUrlString: String?
}

class CasterSearchResult: PodcastSearchResult {
    var podcastSearchType: ResultType?
    var podcastArtist: String?
    var podcastArtUrlString: String?
    var podcastTitle: String?
    var episodes = [Episodes]()
    var id: String!
}

extension CasterSearchResult: Equatable {

    static func ==(lhs: CasterSearchResult, rhs: CasterSearchResult) -> Bool {
        return lhs.id == rhs.id
    }

    
}
