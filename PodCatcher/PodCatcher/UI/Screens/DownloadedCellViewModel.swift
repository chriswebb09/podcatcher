//
//  DownloadedCellViewModel.swift
//  PodCatcher
//
//  Created by Christopher Webb on 5/13/18.
//  Copyright © 2018 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

class DownloadedCellViewModel: CellViewModel {
    
    var mainImage: UIImage! {
        didSet {
            DispatchQueue.main.async {
                self.podcastImage = self.mainImage
            }
        }
    }
    
    var titleText: String! {
        didSet {
            self.episodeName = titleText
        }
    }
    
    var currentState: AudioState = .stopped
    var episodeName: String
    var podcastImage: UIImage!
    
    weak var delegate: TopPodcastCellViewModelDelegate?
    
    init(episode: Episode) {
        self.episodeName = episode.episodeTitle!
        DispatchQueue.main.async {
            self.mainImage = UIImage(data:  episode.podcastArtworkImage! as Data)
        }
        
    }
}
