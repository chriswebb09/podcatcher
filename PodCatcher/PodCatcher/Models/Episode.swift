import Foundation

protocol DataItem: Codable { }

struct Episode: DataItem {
    var mediaUrlString: String
    var audioUrlSting: String
    var title: String
    var podcastTitle: String
    var date: String
    var description: String
    var duration: Double
    var audioUrlString: String?
    var stringDuration: String?
    var tags: [String] = [] 
}

extension Episode: Equatable {
    static func ==(lhs: Episode, rhs: Episode) -> Bool {
        return lhs.audioUrlSting == rhs.audioUrlSting
    }
}
