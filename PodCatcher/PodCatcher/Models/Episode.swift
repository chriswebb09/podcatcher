import Foundation

//struct Episode: DataItem {
//    var mediaUrlString: String
//    var audioUrlSting: String
//    var title: String
//    var podcastTitle: String
//    var date: String
//    var description: String
//    var duration: Double
//    var audioUrlString: String?
//    var stringDuration: String?
//    var tags: [String] = [] 
//}


extension Episode {
    func asEpisodes() -> Episodes? {
        var episodes = Episodes()
        
        episodes.title = self.episodeTitle!
        guard let podcastArtUrl = self.podcastArtUrlString else { return nil }
        episodes.podcastArtUrlString = podcastArtUrl
        episodes.mediaUrlString = self.mediaUrlString!
        episodes.description = self.episodeDescription!
        return episodes
    }
    
}

extension Episode {
    
    var presentationTime: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "mm:ss"
        let date = Date(timeIntervalSince1970: duration)
        return formatter.string(from: date)
    }
}


import UIKit

extension Episodes: Equatable {
    static func ==(lhs: Episodes, rhs: Episodes) -> Bool {
        return lhs.mediaUrlString == rhs.mediaUrlString
    }
}

