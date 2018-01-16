//
//  HttpMethod.swift
//  PodCatcher
//
//  Created by Christopher Webb-Orenstein on 1/15/18.
//  Copyright © 2018 Christopher Webb-Orenstein. All rights reserved.
//

import Foundation

enum HttpMethod<A> {
    
    case get
    case post(payload: A?)
    
    var method: String {
        switch self {
        case .get:
            return "GET"
        case .post:
            return "POST"
        }
    }
    
    func map<B>(f: (A) throws -> B) rethrows -> HttpMethod<B> {
        switch self {
        case .get:
            return .get
        case .post(let payload):
            guard let payload = payload else { return .post(payload: nil) }
            return .post(payload: try f(payload))
        }
    }
}
