import Foundation

struct URLConstructor {
    
    var searchTerm: String
    
    func build(searchTerm: String) -> URL? {
        let encodedQuery = searchTerm.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        let urlString = URLRouter.base.url + URLRouter.path.url + encodedQuery
        return URL(string: urlString)
    }
}
