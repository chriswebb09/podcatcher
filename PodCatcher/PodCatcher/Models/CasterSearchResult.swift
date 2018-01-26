import Foundation

enum ResultType {
    case podcast, topic, caster, term
}

protocol PodcastSearchResult {
    var podcastArtUrlString: String? { get set }
    var podcastTitle: String? { get set }
    var podcastArtist: String? { get set }
    var podcastSearchType: ResultType? { get set }
}

struct TermSearchResult: PodcastSearchResult {
    var podcastSearchType: ResultType?
    var podcastArtist: String?
    var podcastTitle: String?
    var podcastArtUrlString: String?
}

struct CasterSearchResult: DataItem, PodcastSearchResult {
    
    var podcastSearchType: ResultType?
    var podcastArtist: String?
    var podcastArtUrlString: String?
    var podcastTitle: String?
    var episodes = [Episode]()
    var category = ""
    var id: String!
    var artistId: String!
    var feedUrl: String?
    var itunesUrlString: String?
    var index: Int!
    var tags: [String] = []
    
    init() { }
    
    init(from decoder: Decoder) throws {
        
    }
    
    func encode(to encoder: Encoder) throws {
        
    }
    
    init?(json: [String: Any]) {
        let list = ["Joe Rogan", "HowStuffWorks", "ESPN, ESPN Films, 30for30", "Matt Behdjou", "Mike & Matt", "Tenderfoot", "Mathis Entertainment, Inc."]
        //print("\n\n\n")
        //print("HERE - 2")
       // print("\n\n\n\n")
       // print(json)
        guard !list.contains(json["artistName"] as! String) else { return nil }
        guard let artUrl = json["artworkUrl600"] as? String else { return }
        guard let artistName = json["artistName"] as? String else { return }
        guard let trackName = json["trackName"] as? String else { return }
        guard let title = json["collectionName"] as? String else { return }
        guard let releaseDate = json["releaseDate"] as? String else { return nil }
        guard let id = json["collectionId"] as? Int else { return }
        guard let feedUrl = json["feedUrl"] as? String else { return }
        
        var episode = Episode(mediaUrlString: "", audioUrlSting: "", title: trackName, podcastTitle: title, date: releaseDate, description: "test", duration: 29134, audioUrlString: nil, stringDuration: nil, tags: [])
        self.episodes.append(episode)
        self.podcastArtUrlString = artUrl
        self.podcastArtist = artistName
        self.podcastTitle = title
        self.feedUrl = feedUrl
        self.id = String(describing: id)
        if let artistId = json["artistId"] as? Int {
            self.artistId = String(describing: artistId)
        }
      //  self.artistId =
        if let genres = json["genres"] as? [String] {
            for genre in genres {
                let trimmedGenre = genre.trimmingCharacters(in: .whitespacesAndNewlines)
                if !tags.contains(trimmedGenre) {
                    tags.append(trimmedGenre)
                }
            }
        }
        
        if let collectionName = json["collectionName"] as? String {
           // print("podcast title")
            self.podcastTitle = collectionName
        }
        
        if let artistName = json["artistName"] as? String {
          //  print(artistName)
            //print("Artist name")
            self.podcastArtist = artistName
        }
        
        if let primaryGenre = json["primaryGenreName"] as? String {
           // print("Primary genre")
            //print(primaryGenre)
            self.category = primaryGenre
        }
        
        if let artistViewUrl = json["artistViewUrl"] as? String {
            self.itunesUrlString = artistViewUrl
        }
        
        if (json["country"] as? String) != nil {
          //  print(country)
        }
        for tag in tags {
            let trimmedTag = tag.trimmingCharacters(in: .whitespacesAndNewlines)
            if !episode.tags.contains(trimmedTag) {
                episode.tags.append(trimmedTag)
            }
        }
    
    //print(self)
    }
}

extension CasterSearchResult: Equatable {
    
    static func ==(lhs: CasterSearchResult, rhs: CasterSearchResult) -> Bool {
        return lhs.id == rhs.id
    }
    
    var providerId: String {
        return self.id
    }
    
    func nsTags() -> [NSString] {
        var nsTags = [NSString]()
        
        for tag in tags {
            print(tag)
            nsTags.append(tag as NSString)
        }
        return nsTags
    }
}
