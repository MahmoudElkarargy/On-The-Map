//
//  LoginTokenResponse.swift
//  On The Map
//
//  Created by Mahmoud Elkarargy on 5/2/20.
//  Copyright © 2020 Mahmoud Elkarargy. All rights reserved.
//

import Foundation

struct LoginTokenResponse: Codable {
    let account: Account
    let session: Session
}
struct Account: Codable {
    let registered: Bool
    let key: String
}
struct Session: Codable {
    let id: String
    let expiration: String
}

// MARK: Response Template when user not found
struct ErrorResponse: Codable{
    let status: Int
    let error: String
}

extension ErrorResponse: LocalizedError {
    var errorDescription: String? {
        return error
    }
}
