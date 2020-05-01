//
//  UdacityClient.swift
//  On The Map
//
//  Created by Mahmoud Elkarargy on 5/2/20.
//  Copyright © 2020 Mahmoud Elkarargy. All rights reserved.
//

import Foundation

class UdacityClient{
    enum EndPoints{
        static let base = "https://onthemap-api.udacity.com/v1"
        
        case createSession
        
        var StringValue: String{
            switch self {
            case .createSession:
                return EndPoints.base + "/session"
            }
        }
    }
}
