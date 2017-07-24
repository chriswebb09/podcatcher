import UIKit

final class iTunesAPIClient {
    
    static func search(for query: String, completion: @escaping (Response) -> Void) {
        let urlConstructor = URLConstructor(searchTerm: query)
        guard let url = urlConstructor.build(searchTerm: urlConstructor.searchTerm) else { return }
        URLSession(configuration: .ephemeral).dataTask(with: URLRequest(url: url)) { data, response, error in
            if let error = error {
                completion(.failed(error))
            } else {
                do {
                    guard let data = data else { return }
                    guard let responseObject = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else { return }
                    DispatchQueue.main.async {
                        completion(.success(responseObject))
                    }
                }
            }
            }.resume()
    }
    
    static func search(forLookup: String?, completion: @escaping (Response) -> Void) {
        guard let forLookup = forLookup else { return }
        guard let url = URL(string: "https://itunes.apple.com/lookup?id=\(forLookup)&entity=podcast&limit=15") else { return }
        URLSession(configuration: .ephemeral).dataTask(with: URLRequest(url: url)) { data, response, error in
            if let error = error {
                completion(.failed(error))
            } else {
                do {
                    guard let data = data else { return }
                    guard let responseObject = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else { return }
                    DispatchQueue.main.async {
                        completion(.success(responseObject))
                    }
                }
            }
            }.resume()
    }
}
