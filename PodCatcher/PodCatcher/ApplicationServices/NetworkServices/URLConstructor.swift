import Foundation

typealias JSON = [String : Any]

enum Response {
    case success(JSON?), failed(Error)
}

struct URLConstructor {
    
    var searchTerm: String
    
    func build(searchTerm: String) -> URL? {
        let encodedQuery = searchTerm.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        let urlString = URLRouter.base.url + URLRouter.path.url + encodedQuery
        print(urlString)
        return URL(string: urlString)
    }
}

enum URLRouter {
    
    case base, path
    
    var url: String {
        switch self {
        case .base:
            return "https://itunes.apple.com"
        case .path:
            return "/search?country=US&media=podcast&limit=15&term="
            
        }
    }
}

enum URLPath {
    case podcastAuth(searchTerm: String), keyTerm(searchTerm: String)
}
