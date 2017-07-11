import Foundation

protocol ContentProvider {
    var providerId: String { get }
    var feedUrlString: String { get }
    var mediaItems: [Content] { get }
}

protocol Content {
    var title: String { get }
    var mediaUrlString: String { get } 
}
