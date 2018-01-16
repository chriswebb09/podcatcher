//
//  Resource.swift
//  PodCatcher
//
//  Created by Christopher Webb-Orenstein on 1/4/18.
//  Copyright © 2018 Christopher Webb-Orenstein. All rights reserved.
//

import Foundation



struct Resource<A> {
    var url: URL
    var parse: (Data) -> A?
    var method: HttpMethod<Data> = .get
}

extension Resource {
    var urlRequest: URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method.method
        if case .post(let payload) = method {
            request.httpBody = payload
        }
        return request
    }
}

extension Resource {
    
     init(url: URL, parseJSON: @escaping (Any) -> A?) {
        self.url = url
        self.method = .get
        self.parse = { data in
            let json = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions())
            return json.flatMap(parseJSON)
        }
    }
    
    init(url: URL, method: HttpMethod<Any>, parseJSON: @escaping (Any) -> A?) throws {
        self.url = url
        self.method = try method.map { jsonObject in
            try JSONSerialization.data(withJSONObject: jsonObject, options: JSONSerialization.WritingOptions())
        }
        self.parse = { data in
            let json = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions())
            return json.flatMap(parseJSON)
        }
    }
}




