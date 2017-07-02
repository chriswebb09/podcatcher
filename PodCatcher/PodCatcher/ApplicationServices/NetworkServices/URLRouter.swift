import Foundation

enum URLRouter {
    
    case base, path
    
    var url: String {
        switch self {
        case .base:
            return "https://itunes.apple.com"
        case .path:
            return "/search?country=US&media=podcast&limit=100&term="
           
        }
    }
}


enum URLPath {
    case podcastAuth(searchTerm: String), keyTerm(searchTerm: String)
}


 //"/search?country=US&media=podcast&entity=podcast&limit=100&term="


//itunes.apple.com/search?country=US&media=podcast&limit=100&entity=podcastAuthor&term=new
