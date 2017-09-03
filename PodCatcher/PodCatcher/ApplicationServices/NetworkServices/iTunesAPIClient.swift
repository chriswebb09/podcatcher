import UIKit

typealias JSON = [String : Any]

enum Response {
    case success(JSON?), failed(Error)
}

public enum Result<A> {
    case success(A)
    case error(Error)
}

extension Result {
    public init(_ value: A?, or error: Error) {
        if let value = value {
            self = .success(value)
        } else {
            self = .error(error)
        }
    }
    
    public var value: A? {
        guard case .success(let v) = self else { return nil }
        return v
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

final class iTunesAPIClient {
    
    static func search(for query: String, completion: @escaping (Response) -> Void) {
        guard let url = build(searchTerm: query) else { return }
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
            }}.resume()
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
            }}.resume()
    }
    
    static func build(searchTerm: String) -> URL? {
        guard let encodedQuery = searchTerm.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return nil }
        let urlString = URLRouter.base.url + URLRouter.path.url + encodedQuery
        print(urlString)
        return URL(string: urlString)
    }
}

struct SearchResultsIteractor {
    
    var searchTerm: String? = ""
    var lookup: String? = ""
    
    mutating func setSearch(term: String?) {
        searchTerm = term
    }
    
    mutating func setLookup(term: String?) {
        lookup = term
    }
    
    func searchForTracksFromLookup(completion: @escaping (_ results: [[String: Any]?]? , _ error: Error?) -> Void) {
        iTunesAPIClient.search(forLookup: lookup) { response in
            switch response {
            case .success(let data):
                guard let data = data else { return }
                let resultsData = data["results"] as? [[String: Any]?]?
                DispatchQueue.main.async {
                    guard let resultsData = resultsData else { return }
                    completion(resultsData, nil)
                }
            case .failed(let error):
                completion(nil, error)
            }
        }
    }
    
    func searchForTracks(completion: @escaping (_ results: [CasterSearchResult]? , _ error: Error?) -> Void) {
        guard let searchTerm = searchTerm else { return }
        iTunesAPIClient.search(for: searchTerm) { response in
            switch response {
            case .success(let data):
                guard let data = data else { return }
                let resultsData = data["results"] as? [[String: Any]?]?
                if let resultsData = resultsData {
                    var results = [CasterSearchResult]()
                    resultsData?.forEach { resultingData in
                        guard let resultingData = resultingData else { return }
                        if let caster = CasterSearchResult(json: resultingData) {
                            results.append(caster)
                        }
                    }
                    DispatchQueue.main.async {
                        completion(results, nil)
                    }
                }
            case .failed(let error):
                completion(nil, error)
            }
        }
    }
}
