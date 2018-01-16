import Foundation

struct TopItem: DataItem {
    var title : String
    var id: String
    var pubDate: String
    var category: String
    var itunesLinkString: String
    
    enum CodingKeys: String, CodingKey {
        case title
        case id
        case pubDate
        case category
        case itunesLinkString
    }
}

extension TopItem: Equatable {
    static func ==(lhs: TopItem, rhs: TopItem) -> Bool {
        return lhs.id == rhs.id && lhs.itunesLinkString == rhs.itunesLinkString
    }
}
