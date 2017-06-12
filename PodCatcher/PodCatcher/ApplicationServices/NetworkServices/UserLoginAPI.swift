//
//  UserLoginAPI.swift
//  PodCatcher
//
//  Created by Christopher Webb-Orenstein on 6/7/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import Foundation

class UserLoginAPIClient {
    
    static func login(with username: String, and password: String, completion: @escaping (Bool, [String: Any]?) -> Void) {
        let testUser: Any = username
        let testUseremail: Any = password
        
        Caster.testData { casterData in
            let testCaster: Any = casterData
            print(testCaster)
            completion(true,
                       ["username": testUser,
                        "email": testUseremail,
                        "casters": testCaster,
                        "customGenre": ["new", "test", "stuff"]
                ])
        }
        
    }
}
