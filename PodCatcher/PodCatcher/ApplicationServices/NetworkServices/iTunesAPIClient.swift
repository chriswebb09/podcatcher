import UIKit

enum URLRouter {
    
    case base, path
    
    var url: String {
        switch self {
        case .base:
            return "https://itunes.apple.com"
        case .path:
            return "/search?country=US&media=podcast&entity=podcast&term="
        }
    }
}

struct URLConstructor {
    
    var searchTerm: String
    
    func build(searchTerm: String) -> URL? {
        let encodedQuery = searchTerm.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        let urlString = URLRouter.base.url + URLRouter.path.url + encodedQuery
        return URL(string: urlString)
    }
}

final class iTunesAPIClient: NSObject {
    
    private func showNetworkActivity() {
        
        // Turn on network indicator in status bar
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    private func hideNetworkActivity() {
        
        // Turn off network indicator in status bar
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    
    static func search(for query: String, completion: @escaping (Response) -> Void) {
        let urlConstructor = URLConstructor(searchTerm: query)
        guard let url = urlConstructor.build(searchTerm: urlConstructor.searchTerm) else { return }
        URLSession(configuration: .ephemeral).dataTask(with: URLRequest(url: url)) { data, response, error in
            if let error = error {
                completion(.failed(error))
            } else {
                do {
                    let responseObject = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any]
                    DispatchQueue.main.async {
                        completion(.success(responseObject!))
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
            }.resume()
    }
}
