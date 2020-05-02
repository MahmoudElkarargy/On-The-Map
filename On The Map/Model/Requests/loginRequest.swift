//
//  loginRequest.swift
//  On The Map
//
//  Created by Mahmoud Elkarargy on 5/2/20.
//  Copyright © 2020 Mahmoud Elkarargy. All rights reserved.
//

import Foundation

// MARK: Hold the request parameters for the JSON object.
struct loginData: Codable {
    let username: String
    let password: String
}

struct LoginRequest: Codable {
    let userData: loginData
    
    enum CodingKeys: String, CodingKey {
        case userData = "udacity"
    }
}
