import UIKit

class PodcastEpisode: AudioFile {
    var audioUrlSting: String

//    
//    var audioUrlSting: String {
//        guard let audio = self.audioUrlString else { return "" }
//        return audio
//    }
//    
    var episodeTitle: String?
    var episodeDescription: String?
    var playlistId: String?
    var artistId: String?
    var artworkImage: UIImage?
    var audioUrlString: String?
    var date: Date?
    var stringDate: String?
    var duration: Double?
    
    init() {
        self.audioUrlSting = ""
    }
    
}
